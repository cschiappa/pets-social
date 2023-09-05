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

  //LIKE POST
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

  //GIVE FISH TO POST
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

  //GIVE BONE TO POST
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

  //POST COMMENT
  Future<void> postComment(String postId, String text, String uid, String name,
      String profilePic, List likes) async {
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
          'uid': uid,
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
      String postId, String commentId, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        await _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .update({
          'likes': FieldValue.arrayRemove([uid]),
        });
      } else {
        await _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .update({
          'likes': FieldValue.arrayUnion([uid]),
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
      String postId, String uid, List<dynamic> savedPost) async {
    try {
      if (savedPost.contains(postId)) {
        await _firestore.collection('users').doc(uid).update({
          'savedPost': FieldValue.arrayRemove([postId]),
        });
      } else {
        await _firestore.collection('users').doc(uid).update({
          'savedPost': FieldValue.arrayUnion([postId]),
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  //FOLLOW AND UNFOLLOW USER
  Future<void> followUser(String uid, String followId) async {
    try {
      DocumentSnapshot snap =
          await _firestore.collection('users').doc(uid).get();
      List following = (snap.data()! as dynamic)['following'];

      if (following.contains(followId)) {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayRemove([uid])
        });

        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayRemove([followId])
        });
      } else {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayUnion([uid])
        });

        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayUnion([followId])
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  //BLOCK USER
  Future<void> blockUser(String uid, String blockedId) async {
    try {
      DocumentSnapshot snap =
          await _firestore.collection('users').doc(uid).get();
      List blockedUsers = (snap.data()! as dynamic)['blockedUsers'];

      if (blockedUsers.contains(blockedId)) {
        await _firestore.collection('users').doc(uid).update(
          {
            'blockedUsers': FieldValue.arrayRemove([blockedId])
          },
        );
        print('User unblocked successfully');
      } else {
        await _firestore.collection('users').doc(uid).update(
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
}
