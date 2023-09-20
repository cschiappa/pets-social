import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pets_social/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';
import '../models/post.dart';
import '../models/profile.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //upload post
  Future<String> uploadPost(
    String? description,
    Uint8List file,
    String profileUid,
    String username,
    String profImage,
    String fileType,
  ) async {
    String res = "An error occurred";
    try {
      String photoUrl =
          await StorageMethods().uploadImageToStorage('posts', file, true);

      String postId = const Uuid().v1(); //v1 creates unique id based on time
      ModelPost post = ModelPost(
        description: description ?? "",
        profileUid: profileUid,
        username: username,
        postId: postId,
        datePublished: DateTime.now(),
        postUrl: photoUrl,
        profImage: profImage,
        likes: [],
        fish: [],
        bones: [],
        fileType: fileType,
      );

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
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([profileUid]),
        });
      }
    } catch (e) {
      print(e.toString());
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
      print(e.toString());
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
      print(e.toString());
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
        print('text is empty');
      }
    } catch (e) {
      print(
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
      print(e.toString());
    }
  }

  //DELETE POST
  Future<void> deletePost(String postId) async {
    try {
      _firestore.collection('posts').doc(postId).delete();
    } catch (err) {
      print(err.toString());
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
      print(e.toString());
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
        await _firestore.collection('users').doc(followId).update({
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
        await _firestore.collection('users').doc(followId).update({
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
      print(e.toString());
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
        print('User unblocked successfully');
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
        print('User blocked successfully');
      }
    } catch (e) {
      print('Error blocking user: $e');
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
          photoUrl: photoUrl ??
              'https://i.pinimg.com/474x/eb/bb/b4/ebbbb41de744b5ee43107b25bd27c753.jpg',
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
}
