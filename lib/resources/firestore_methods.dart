import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pets_social/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';
import '../models/post.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //upload post
  Future<String> uploadPost(
    String description,
    Uint8List file,
    String uid,
    String username,
    String profImage,
  ) async {
    String res = "An error occurred";
    try {
      String photoUrl =
          await StorageMethods().uploadImageToStorage('posts', file, true);

      String postId = const Uuid().v1(); //v1 creates unique id based on time
      Post post = Post(
        description: description,
        uid: uid,
        username: username,
        postId: postId,
        datePublished: DateTime.now(),
        postUrl: photoUrl,
        profImage: profImage,
        likes: [],
        fish: [],
        bones: [],
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

  Future<void> likePost(String postId, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid]),
        });
      } else {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid]),
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> giveFishToPost(String postId, String uid, List fish) async {
    try {
      if (fish.contains(uid)) {
        await _firestore.collection('posts').doc(postId).update({
          'fish': FieldValue.arrayRemove([uid]),
        });
      } else {
        await _firestore.collection('posts').doc(postId).update({
          'fish': FieldValue.arrayUnion([uid]),
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> giveBoneToPost(String postId, String uid, List bones) async {
    try {
      if (bones.contains(uid)) {
        await _firestore.collection('posts').doc(postId).update({
          'bones': FieldValue.arrayRemove([uid]),
        });
      } else {
        await _firestore.collection('posts').doc(postId).update({
          'bones': FieldValue.arrayUnion([uid]),
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
