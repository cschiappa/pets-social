import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pets_social/core/constants/firebase_constants.dart';
import 'package:pets_social/core/providers/storage_methods.dart';
import 'package:pets_social/features/notification/controller/notification_provider.dart';
import 'package:pets_social/features/notification/repository/notification_repository.dart';
import 'package:pets_social/models/profile.dart';
import 'package:uuid/uuid.dart';

class ProfileRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final StorageRepository _storageRepository;
  final NotificationRepository _notificationRepository;
  ProfileRepository({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
    required StorageRepository storageRepository,
    required NotificationRepository notificationRepository,
  })  : _firestore = firestore,
        _auth = auth,
        _storageRepository = storageRepository,
        _notificationRepository = notificationRepository;

  //GET PROFILE DATA
  Stream<ModelProfile> getProfileData(String? profileUid) {
    return _firestore.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('profiles').doc(profileUid).snapshots().map((snap) => ModelProfile.fromSnap(snap));
  }

  //GET PROFILES FROM CURRENT USER
  Stream<QuerySnapshot<Map<String, dynamic>>> getAccountProfiles() {
    return FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('profiles').snapshots();
  }

  //GET PROFILE FROM POST
  Future<ModelProfile> getProfileFromPost(String profileUid) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collectionGroup('profiles').where('profileUid', isEqualTo: profileUid).get();

    return ModelProfile.fromSnap(querySnapshot.docs.first);
  }

  //FOLLOW AND UNFOLLOW USER
  Future<void> followUser(String profileUid, String followId) async {
    try {
      final profilePath = FirestorePath.profile(_auth.currentUser!.uid, profileUid);

      DocumentSnapshot snap = await _firestore.collection('users').doc(_auth.currentUser!.uid).collection('profiles').doc(profileUid).get();
      List following = (snap.data()! as dynamic)['following'];

      if (following.contains(followId)) {
        var profileSnap = await _firestore.collectionGroup('profiles').where('profileUid', isEqualTo: followId).get();
        DocumentSnapshot profileDoc = profileSnap.docs.first;
        profileDoc.reference.update({
          'followers': FieldValue.arrayRemove([profileUid])
        });

        await _firestore.doc(profilePath).update({
          'following': FieldValue.arrayRemove([followId])
        });
      } else {
        var profileSnap = await _firestore.collectionGroup('profiles').where('profileUid', isEqualTo: followId).get();
        DocumentSnapshot profileDoc = profileSnap.docs.first;
        profileDoc.reference.update({
          'followers': FieldValue.arrayUnion([profileUid])
        });

        await _firestore.doc(profilePath).update({
          'following': FieldValue.arrayUnion([followId])
        });

        _notificationRepository.followNotificationMethod(followId, profileUid);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  //BLOCK USER
  Future<void> blockUser(String profileUid, String blockedId) async {
    try {
      final profilePath = FirestorePath.profile(_auth.currentUser!.uid, profileUid);

      DocumentSnapshot snap = await _firestore.collection('users').doc(_auth.currentUser!.uid).collection('profiles').doc(profileUid).get();
      List blockedUsers = (snap.data()! as dynamic)['blockedUsers'];

      if (blockedUsers.contains(blockedId)) {
        await _firestore.doc(profilePath).update(
          {
            'blockedUsers': FieldValue.arrayRemove([blockedId])
          },
        );
        debugPrint('User unblocked successfully');
      } else {
        await _firestore.doc(profilePath).update(
          {
            'blockedUsers': FieldValue.arrayUnion([blockedId]),
            'following': FieldValue.arrayRemove([blockedId]),
            'followers': FieldValue.arrayRemove([blockedId]),
          },
        );
        debugPrint('User blocked successfully');
      }
    } catch (e) {
      debugPrint('Error blocking user: $e');
    }
  }

  //CREATE NEW PROFILE
  Future<String> createProfile({
    required String uid,
    required String username,
    String? bio,
    Uint8List? file,
    String? photoUrl,
  }) async {
    String res = "Some error ocurred";

    try {
      if (username.isNotEmpty) {
        if (file != null) {
          photoUrl = await _storageRepository.uploadImageToStorage('profilePics', file, false);
        } else {
          photoUrl = 'https://i.pinimg.com/474x/eb/bb/b4/ebbbb41de744b5ee43107b25bd27c753.jpg';
        }

        String profileUid = const Uuid().v1();

        ModelProfile profile = ModelProfile(
          username: username,
          profileUid: profileUid,
          email: FirebaseAuth.instance.currentUser!.email.toString(),
          bio: bio ?? "",
          photoUrl: photoUrl,
          following: [],
          followers: [],
          savedPost: [],
          blockedUsers: [],
        );

        final profilePath = FirestorePath.profile(uid, profile.profileUid);

        await _firestore.doc(profilePath).set(profile.toJson());

        res = "Profile created successfully";
      } else {
        res = "Please choose a username";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  //DELETE PROFILE
  Future<void> deleteProfile(profileUid, context) async {
    if (profileUid != null) {
      try {
        final profilePath = FirestorePath.profile(_auth.currentUser!.uid, profileUid);
        await _firestore.doc(profilePath).delete();
      } catch (e) {
        debugPrint('Error deleting account: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('There was an error deleting the account.'),
          ),
        );
      }
    }
  }

  //UPDATE PROFILE
  Future<String> updateProfile({
    required String profileUid,
    Uint8List? file,
    required String newUsername,
    required String newBio,
    String? photoUrl,
  }) async {
    String res = "Some error occurred";
    try {
      final profilePath = FirestorePath.profile(_auth.currentUser!.uid, profileUid);
      if (newUsername.length <= 15 && newBio.length <= 150) {
        if (file != null) {
          photoUrl = await _storageRepository.uploadImageToStorage('profilePics', file, false);

          await _firestore.doc(profilePath).update({
            'username': newUsername,
            'bio': newBio,
            'photoUrl': photoUrl,
          });
        } else {
          // Update the user's profile without changing the image URL
          await _firestore.doc(profilePath).update({
            'username': newUsername,
            'bio': newBio,
          });
        }

        res = 'Profile updated succesfully';
      } else {
        res = 'Username must be 30 characters or less and bio must be 150 characters or less.';
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  //GET BLOCKED PROFILES DATA
  Stream<QuerySnapshot<Map<String, dynamic>>> getBlockedProfiles(List<dynamic>? blockedProfiles) {
    return FirebaseFirestore.instance.collectionGroup('profiles').where('profileUid', whereIn: blockedProfiles).snapshots();
  }
}
