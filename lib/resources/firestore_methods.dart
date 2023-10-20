import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pets_social/resources/firebase_messaging.dart';
import 'package:pets_social/resources/storage_methods.dart';

import 'package:uuid/uuid.dart';
import '../models/post.dart';
import '../models/profile.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //upload post
  Future<String> uploadPost(
    String uid,
    String? description,
    Uint8List file,
    String profileUid,
    String username,
    String profImage,
    String fileType,
    Uint8List thumbnail,
  ) async {
    String res = "An error occurred";
    try {
      String photoUrl =
          await StorageMethods().uploadImageToStorage('posts', file, true);

      String videoThumbnail = await StorageMethods()
          .uploadImageToStorage('videoThumbnails', thumbnail, true);

      String postId = const Uuid().v1(); //v1 creates unique id based on time

      ModelPost post = ModelPost(
          uid: uid,
          description: description ?? "",
          profileUid: profileUid,
          postId: postId,
          datePublished: DateTime.now(),
          postUrl: photoUrl,
          likes: [],
          fish: [],
          bones: [],
          fileType: fileType,
          videoThumbnail: videoThumbnail);

      _firestore.collection('posts').doc(postId).set(
            post.toJson(),
          );
      res = "success";
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  //LIKE POST
  Future<void> likePost(String postId, String profileUid, List likes) async {
    try {
      if (likes.contains(profileUid)) {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([profileUid]),
        });
      } else {
        await _firestore.collection('posts').doc(postId).update(
          {
            'likes': FieldValue.arrayUnion([profileUid]),
          },
        );

        //get user that made the post
        final user = await _firestore
            .collection('posts')
            .doc(postId)
            .get()
            .then((value) {
          return value.data()!['uid'];
        });

        //get profile that liked the post
        final QuerySnapshot<Map<String, dynamic>> querySnapshot =
            await _firestore
                .collectionGroup('profiles')
                .where('profileUid', isEqualTo: profileUid)
                .get();

        if (querySnapshot.docs.isNotEmpty) {
          final actionUser = querySnapshot.docs[0].data()['username'];

          await FirebaseApi().sendNotificationToUser(
              user, 'New notification', '$actionUser liked your post.');
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  //GIVE FISH TO POST
  Future<void> giveFishToPost(
      String postId, String profileUid, List fish) async {
    try {
      if (fish.contains(profileUid)) {
        await _firestore.collection('posts').doc(postId).update({
          'fish': FieldValue.arrayRemove([profileUid]),
        });
      } else {
        await _firestore.collection('posts').doc(postId).update({
          'fish': FieldValue.arrayUnion([profileUid]),
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  //GIVE BONE TO POST
  Future<void> giveBoneToPost(
      String postId, String profileUid, List bones) async {
    try {
      if (bones.contains(profileUid)) {
        await _firestore.collection('posts').doc(postId).update({
          'bones': FieldValue.arrayRemove([profileUid]),
        });
      } else {
        await _firestore.collection('posts').doc(postId).update({
          'bones': FieldValue.arrayUnion([profileUid]),
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  //POST COMMENT
  Future<void> postComment(String postId, String text, String profileUid,
      String name, String profilePic, List likes) async {
    try {
      if (text.isNotEmpty) {
        String commentId = const Uuid().v1();
        await _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          'profilePic': profilePic,
          'name': name,
          'profileUid': profileUid,
          'text': text,
          'commentId': commentId,
          'datePublished': DateTime.now(),
          'likes': likes,
          'postId': postId
        });
      } else {
        debugPrint('text is empty');
      }
    } catch (e) {
      debugPrint(
        e.toString(),
      );
    }
  }

  //LIKE COMMENT
  Future<void> likeComment(
      String postId, String commentId, String profileUid, List likes) async {
    try {
      if (likes.contains(profileUid)) {
        await _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .update({
          'likes': FieldValue.arrayRemove([profileUid]),
        });
      } else {
        await _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .update({
          'likes': FieldValue.arrayUnion([profileUid]),
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  //DELETE POST
  Future<void> deletePost(String postId) async {
    try {
      _firestore.collection('posts').doc(postId).delete();
    } catch (err) {
      debugPrint(err.toString());
    }
  }

//SAVE AND UNSAVE POST
  Future<void> savePost(
      String postId, String profileUid, List<dynamic> savedPost) async {
    try {
      if (savedPost.contains(postId)) {
        await _firestore
            .collection('users')
            .doc(_auth.currentUser!.uid)
            .collection('profiles')
            .doc(profileUid)
            .update({
          'savedPost': FieldValue.arrayRemove([postId]),
        });
      } else {
        await _firestore
            .collection('users')
            .doc(_auth.currentUser!.uid)
            .collection('profiles')
            .doc(profileUid)
            .update({
          'savedPost': FieldValue.arrayUnion([postId]),
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  //FOLLOW AND UNFOLLOW USER
  Future<void> followUser(String profileUid, String followId) async {
    try {
      DocumentSnapshot snap = await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('profiles')
          .doc(profileUid)
          .get();
      List following = (snap.data()! as dynamic)['following'];

      if (following.contains(followId)) {
        var profileSnap = await _firestore
            .collectionGroup('profiles')
            .where('profileUid', isEqualTo: followId)
            .get();
        DocumentSnapshot profileDoc = profileSnap.docs.first;
        profileDoc.reference.update({
          'followers': FieldValue.arrayRemove([profileUid])
        });

        await _firestore
            .collection('users')
            .doc(_auth.currentUser!.uid)
            .collection('profiles')
            .doc(profileUid)
            .update({
          'following': FieldValue.arrayRemove([followId])
        });
      } else {
        var profileSnap = await _firestore
            .collectionGroup('profiles')
            .where('profileUid', isEqualTo: followId)
            .get();
        DocumentSnapshot profileDoc = profileSnap.docs.first;
        profileDoc.reference.update({
          'followers': FieldValue.arrayUnion([profileUid])
        });

        await _firestore
            .collection('users')
            .doc(_auth.currentUser!.uid)
            .collection('profiles')
            .doc(profileUid)
            .update({
          'following': FieldValue.arrayUnion([followId])
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  //BLOCK USER
  Future<void> blockUser(String profileUid, String blockedId) async {
    try {
      DocumentSnapshot snap = await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection('profiles')
          .doc(profileUid)
          .get();
      List blockedUsers = (snap.data()! as dynamic)['blockedUsers'];

      if (blockedUsers.contains(blockedId)) {
        await _firestore
            .collection('users')
            .doc(_auth.currentUser!.uid)
            .collection('profiles')
            .doc(profileUid)
            .update(
          {
            'blockedUsers': FieldValue.arrayRemove([blockedId])
          },
        );
        debugPrint('User unblocked successfully');
      } else {
        await _firestore
            .collection('users')
            .doc(_auth.currentUser!.uid)
            .collection('profiles')
            .doc(profileUid)
            .update(
          {
            'blockedUsers': FieldValue.arrayUnion([blockedId])
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
          photoUrl = await StorageMethods()
              .uploadImageToStorage('profilePics', file, false);
        } else {
          photoUrl =
              'https://i.pinimg.com/474x/eb/bb/b4/ebbbb41de744b5ee43107b25bd27c753.jpg';
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

        var profileCollection = _firestore
            .collection('users')
            .doc(uid)
            .collection('profiles')
            .doc(profile.profileUid);

        await profileCollection.set(profile.toJson());

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
    final User? user = FirebaseAuth.instance.currentUser;
    if (profileUid != null) {
      try {
        //Delete the user's profile from Firestore collection
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .collection('profiles')
            .doc(profileUid)
            .delete();
      } catch (e) {
        // Handle any errors that may occur during deletion
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
      if (newUsername.length <= 15 && newBio.length <= 150) {
        if (file != null) {
          photoUrl = await StorageMethods()
              .uploadImageToStorage('profilePics', file, false);

          await FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .collection('profiles')
              .doc(profileUid)
              .update({
            'username': newUsername,
            'bio': newBio,
            'photoUrl': photoUrl,
          });
        } else {
          // Update the user's profile without changing the image URL
          await FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .collection('profiles')
              .doc(profileUid)
              .update({
            'username': newUsername,
            'bio': newBio,
          });
        }

        res = 'Profile updated succesfully';
      } else {
        res =
            'Username must be 30 characters or less and bio must be 150 characters or less.';
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  //UPDATE POST
  Future<String> updatePost({
    required String postId,
    required String newDescription,
  }) async {
    String res = "Some error occurred";
    try {
      if (newDescription.length <= 2000) {
        await FirebaseFirestore.instance
            .collection('posts')
            .doc(postId)
            .update({
          'description': newDescription,
        });

        res = 'Post updated succesfully';
      } else {
        res = 'Description must be 2000 characters or less.';
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }
}
