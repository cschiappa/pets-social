import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pets_social/core/providers/firebase_providers.dart';
import 'package:pets_social/models/feedback.dart';
import 'package:pets_social/features/notification/repository/notification_repository.dart';
import 'package:pets_social/core/constants/firebase_constants.dart';
import 'package:pets_social/core/providers/storage_methods.dart';

import 'package:uuid/uuid.dart';
import '../../../models/post.dart';
import '../../../models/profile.dart';

class PostRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final StorageRepository _storageRepository;
  PostRepository({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
    required StorageRepository storageRepository,
  })  : _firestore = firestore,
        _auth = auth,
        _storageRepository = storageRepository;

  //UPLOAD POST
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
      String photoUrl = await _storageRepository.uploadImageToStorage('posts', file, true);

      String videoThumbnail = await _storageRepository.uploadImageToStorage('videoThumbnails', thumbnail, true);

      String postId = const Uuid().v1();
      final String postPath = FirestorePath.post(postId);

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
        videoThumbnail: videoThumbnail,
      );

      _firestore.doc(postPath).set(
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
      final postPath = FirestorePath.post(postId);

      if (likes.contains(profileUid)) {
        await _firestore.doc(postPath).update({
          'likes': FieldValue.arrayRemove([profileUid]),
        });
      } else {
        await _firestore.doc(postPath).update(
          {
            'likes': FieldValue.arrayUnion([profileUid]),
          },
        );

        NotificationRepository().notificationMethod(postId, profileUid, 'liked');
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  //GIVE FISH TO POST
  Future<void> giveFishToPost(String postId, String profileUid, List fish) async {
    try {
      final postPath = FirestorePath.post(postId);

      if (fish.contains(profileUid)) {
        await _firestore.doc(postPath).update({
          'fish': FieldValue.arrayRemove([profileUid]),
        });
      } else {
        await _firestore.doc(postPath).update(
          {
            'fish': FieldValue.arrayUnion([profileUid]),
          },
        );

        NotificationRepository().notificationMethod(postId, profileUid, 'gave a fish to');
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  //GIVE BONE TO POST
  Future<void> giveBoneToPost(String postId, String profileUid, List bones) async {
    try {
      final postPath = FirestorePath.post(postId);

      if (bones.contains(profileUid)) {
        await _firestore.doc(postPath).update({
          'bones': FieldValue.arrayRemove([profileUid]),
        });
      } else {
        await _firestore.doc(postPath).update(
          {
            'bones': FieldValue.arrayUnion([profileUid]),
          },
        );

        NotificationRepository().notificationMethod(postId, profileUid, 'gave a bone to');
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  //POST COMMENT
  Future<void> postComment(String postId, String text, String profileUid, String name, String profilePic, List likes) async {
    try {
      String commentId = const Uuid().v1();
      final commentPath = FirestorePath.comment(postId, commentId);
      if (text.isNotEmpty) {
        await _firestore.doc(commentPath).set({'profilePic': profilePic, 'name': name, 'profileUid': profileUid, 'text': text, 'commentId': commentId, 'datePublished': DateTime.now(), 'likes': likes, 'postId': postId});
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
  Future<void> likeComment(String postId, String commentId, String profileUid, List likes) async {
    try {
      final commentPath = FirestorePath.comment(postId, commentId);
      if (likes.contains(profileUid)) {
        await _firestore.doc(commentPath).update({
          'likes': FieldValue.arrayRemove([profileUid]),
        });
      } else {
        await _firestore.doc(commentPath).update({
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
      final QuerySnapshot<Map<String, dynamic>> notification = await _firestore.collection('notifications').where('postId', isEqualTo: postId).get();

      for (QueryDocumentSnapshot<Map<String, dynamic>> documentSnapshot in notification.docs) {
        await documentSnapshot.reference.delete();
      }
      _firestore.collection('posts').doc(postId).delete();
    } catch (err) {
      debugPrint(err.toString());
    }
  }

//SAVE AND UNSAVE POST
  Future<void> savePost(String postId, String profileUid, List<dynamic> savedPost) async {
    try {
      final profilePath = FirestorePath.profile(_auth.currentUser!.uid, profileUid);

      if (savedPost.contains(postId)) {
        await _firestore.doc(profilePath).update({
          'savedPost': FieldValue.arrayRemove([postId]),
        });
      } else {
        await _firestore.doc(profilePath).update({
          'savedPost': FieldValue.arrayUnion([postId]),
        });
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  //UPDATE POST
  Future<String> updatePost({
    required String postId,
    required String newDescription,
  }) async {
    String res = "Some error occurred";
    try {
      final postPath = FirestorePath.post(postId);
      if (newDescription.length <= 2000) {
        await _firestore.doc(postPath).update({
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

  //UPLOAD FEEDBACK
  Future<String> uploadFeedback(
    String summary,
    String description,
  ) async {
    String res = "An error occurred";

    try {
      String feedbackId = const Uuid().v1();
      final String feedbackPath = FirestorePath.feedback(feedbackId);

      ModelFeedback feedback = ModelFeedback(
        summary: summary,
        description: description,
        datePublished: DateTime.now(),
      );

      _firestore.doc(feedbackPath).set(
            feedback.toJson(),
          );
      res = "success";
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  //GET ALL POSTS DESCENDING
  Future<List<ModelPost>> getPostsDescending(ModelProfile profile) async {
    QuerySnapshot querySnapshot = await _firestore.collection('posts').orderBy('datePublished', descending: true).get();

    return querySnapshot.docs.where((doc) => !profile.blockedUsers.contains(doc['profileUid'])).map((doc) => ModelPost.fromSnap(doc)).toList();
  }

  //GET FEED POSTS
  Stream<List<DocumentSnapshot>> getFeedPosts(ModelProfile? profile) {
    return FirebaseFirestore.instance.collection('posts').where('profileUid', whereIn: [...profile!.following, profile.profileUid]).orderBy('datePublished', descending: true).snapshots().map(
          (snapshot) {
            return snapshot.docs.where(
              (doc) {
                return !profile.blockedUsers.contains(doc['profileUid']);
              },
            ).toList();
          },
        );
  }

  //GET SAVED POSTS
  Future<List<ModelPost>> getSavedPosts(List<dynamic> savedPosts) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('posts').where('postId', whereIn: savedPosts).get();

    return querySnapshot.docs.map((doc) => ModelPost.fromSnap(doc)).toList();
  }

  //GET COMMENTS
  Stream<QuerySnapshot<Map<String, dynamic>>> getComments(String postId) {
    return FirebaseFirestore.instance.collection('posts').doc(postId).collection('comments').orderBy('datePublished', descending: true).snapshots();
  }

  //GET PROFILE'S POSTS DESCENDING
  Stream<QuerySnapshot<Map<String, dynamic>>> getProfilePosts(String profileUid) {
    return FirebaseFirestore.instance.collection('posts').where('profileUid', isEqualTo: profileUid).orderBy('datePublished', descending: true).snapshots();
  }
}
