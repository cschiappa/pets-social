import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pets_social/main.dart';
import 'package:pets_social/models/post.dart';
import 'package:pets_social/models/profile.dart';
import 'package:pets_social/providers/auth/auth_provider.dart';
import 'package:pets_social/services/firestore_methods.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'post_provider.g.dart';

@Riverpod(keepAlive: true)
FirestoreMethods firestore(FirestoreRef ref) {
  return FirestoreMethods();
}

@riverpod
Future<List<ModelPost>> getPostsDescending(GetPostsDescendingRef ref) {
  final user = ref.watch(firebaseAuthProvider).currentUser;
  if (user == null) {
    throw AssertionError('User can\'t be null');
  }
  final repository = ref.watch(firestoreProvider);
  return repository.getPostsDescending();
}

@riverpod
Stream<List<DocumentSnapshot>> getFeedPosts(GetFeedPostsRef ref, ModelProfile? profile) {
  final user = ref.watch(firebaseAuthProvider).currentUser;
  if (user == null) {
    throw AssertionError('User can\'t be null');
  }
  final repository = ref.watch(firestoreProvider);
  return repository.getFeedPosts(profile);
}
