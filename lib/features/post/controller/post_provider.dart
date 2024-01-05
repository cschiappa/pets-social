import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pets_social/core/providers/firebase_providers.dart';
import 'package:pets_social/core/providers/storage_methods.dart';
import 'package:pets_social/main.dart';
import 'package:pets_social/models/post.dart';
import 'package:pets_social/models/profile.dart';
import 'package:pets_social/features/post/repository/post_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'post_provider.g.dart';

//POST REPOSITORY PROVIDER
@Riverpod(keepAlive: true)
PostRepository postRepository(PostRepositoryRef ref) {
  return PostRepository(
    firestore: ref.watch(firestoreProvider),
    auth: ref.read(authProvider),
    storageRepository: ref.read(storageRepositoryProvider),
  );
}

//GET ALL POSTS IN DESCENDING
@riverpod
Future<List<ModelPost>> getPostsDescending(GetPostsDescendingRef ref, ModelProfile profile) {
  final repository = ref.watch(postRepositoryProvider);
  return repository.getPostsDescending(profile);
}

//GET FEED POSTS
@riverpod
Stream<List<DocumentSnapshot>> getFeedPosts(GetFeedPostsRef ref, ModelProfile? profile) {
  final repository = ref.watch(postRepositoryProvider);
  return repository.getFeedPosts(profile);
}

//GET SAVED POSTS
@riverpod
Future<List<ModelPost>> getSavedPosts(GetSavedPostsRef ref, List<dynamic> savedPosts) {
  final repository = ref.watch(postRepositoryProvider);
  return repository.getSavedPosts(savedPosts);
}

//GET COMMENTS
@riverpod
Stream<QuerySnapshot<Map<String, dynamic>>> getComments(GetCommentsRef ref, String postId) {
  final repository = ref.watch(postRepositoryProvider);
  return repository.getComments(postId);
}

//GET PROFILE POSTS
@riverpod
Stream<QuerySnapshot<Map<String, dynamic>>> getProfilePosts(GetProfilePostsRef ref, String profileUid) {
  final repository = ref.watch(postRepositoryProvider);
  return repository.getProfilePosts(profileUid);
}
