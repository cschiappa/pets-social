import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pets_social/main.dart';
import 'package:pets_social/models/post.dart';
import 'package:pets_social/models/profile.dart';
import 'package:pets_social/providers/auth/auth_provider.dart';
import 'package:pets_social/services/firestore_methods.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'post_provider.g.dart';

//FIRESTOREMETHODS PROVIDER
@Riverpod(keepAlive: true)
FirestoreMethods firestore(FirestoreRef ref) {
  return FirestoreMethods();
}

//GET ALL POSTS IN DESCENDING
@riverpod
Future<List<ModelPost>> getPostsDescending(GetPostsDescendingRef ref) {
  final repository = ref.watch(firestoreProvider);
  return repository.getPostsDescending();
}

//GET FEED POSTS
@riverpod
Stream<List<DocumentSnapshot>> getFeedPosts(GetFeedPostsRef ref, ModelProfile? profile) {
  final repository = ref.watch(firestoreProvider);
  return repository.getFeedPosts(profile);
}

//GET SAVED POSTS
@riverpod
Future<List<ModelPost>> getSavedPosts(GetSavedPostsRef ref, List<dynamic> savedPosts) {
  final repository = ref.watch(firestoreProvider);
  return repository.getSavedPosts(savedPosts);
}

//GET COMMENTS
@riverpod
Stream<QuerySnapshot<Map<String, dynamic>>> getComments(GetCommentsRef ref, String postId) {
  final repository = ref.watch(firestoreProvider);
  return repository.getComments(postId);
}

//GET PROFILE POSTS
@riverpod
Stream<QuerySnapshot<Map<String, dynamic>>> getProfilePosts(GetProfilePostsRef ref, String profileUid) {
  final repository = ref.watch(firestoreProvider);
  return repository.getProfilePosts(profileUid);
}
