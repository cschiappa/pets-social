import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pets_social/models/profile.dart';
import 'package:pets_social/providers/post/post_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_provider.g.dart';

@riverpod
Stream<QuerySnapshot<Map<String, dynamic>>> getBlockedProfiles(GetBlockedProfilesRef ref, List<dynamic>? blockedProfiles) {
  final repository = ref.watch(firestoreProvider);
  return repository.getBlockedProfiles(blockedProfiles);
}
