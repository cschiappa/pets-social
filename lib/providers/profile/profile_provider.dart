import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pets_social/models/profile.dart';
import 'package:pets_social/providers/post/post_provider.dart';
import 'package:pets_social/services/auth_methods.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_provider.g.dart';

//AUTHMETHODS PROVIDER
@Riverpod(keepAlive: true)
AuthMethods authMethods(AuthMethodsRef ref) {
  return AuthMethods();
}

//GET PROFIILE DATA
@riverpod
Stream<ModelProfile> getProfileData(GetProfileDataRef ref, String? profileUid) {
  final repository = ref.watch(authMethodsProvider);
  return repository.getProfileData(profileUid);
}

//EDIT PROFILE DATA
@riverpod
Future<String> updateProfile(
  UpdateProfileRef ref,
  String profileUid,
  Uint8List? file,
  String newUsername,
  String newBio,
) {
  final repository = ref.watch(firestoreProvider);
  return repository.updateProfile(profileUid: profileUid, file: file, newUsername: newUsername, newBio: newBio);
}

//GET BLOCKED PROFILES
@riverpod
Stream<QuerySnapshot<Map<String, dynamic>>> getBlockedProfiles(GetBlockedProfilesRef ref, List<dynamic>? blockedProfiles) {
  final repository = ref.watch(firestoreProvider);
  return repository.getBlockedProfiles(blockedProfiles);
}

//GET ACCOUNT PROFILES
@riverpod
Stream<QuerySnapshot<Map<String, dynamic>>> getAccountProfiles(GetAccountProfilesRef ref) {
  final repository = ref.watch(authMethodsProvider);
  return repository.getAccountProfiles();
}

@riverpod
Future<ModelProfile> getProfileFromPost(GetProfileFromPostRef ref, String profileUid) {
  final repository = ref.watch(firestoreProvider);
  return repository.getProfileFromPost(profileUid);
}
