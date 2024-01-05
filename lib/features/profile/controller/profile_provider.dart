import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pets_social/core/providers/firebase_providers.dart';
import 'package:pets_social/core/providers/storage_methods.dart';
import 'package:pets_social/features/auth/controller/auth_provider.dart';
import 'package:pets_social/features/auth/repository/auth_repository.dart';
import 'package:pets_social/features/notification/controller/notification_provider.dart';
import 'package:pets_social/features/profile/repository/profile_repository.dart';
import 'package:pets_social/models/profile.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_provider.g.dart';

//PROFILE REPOSITORY PROVIDER
@Riverpod(keepAlive: true)
ProfileRepository profileRepository(ProfileRepositoryRef ref) {
  return ProfileRepository(
    firestore: ref.watch(firestoreProvider),
    auth: ref.read(authProvider),
    storageRepository: ref.read(storageRepositoryProvider),
    notificationRepository: ref.read(notificationRepositoryProvider),
  );
}

//GET PROFIILE DATA
@riverpod
Stream<ModelProfile> getProfileData(GetProfileDataRef ref, String? profileUid) {
  final repository = ref.watch(profileRepositoryProvider);
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
  final repository = ref.watch(profileRepositoryProvider);
  return repository.updateProfile(profileUid: profileUid, file: file, newUsername: newUsername, newBio: newBio);
}

//GET BLOCKED PROFILES
@riverpod
Stream<QuerySnapshot<Map<String, dynamic>>> getBlockedProfiles(GetBlockedProfilesRef ref, List<dynamic>? blockedProfiles) {
  final repository = ref.watch(profileRepositoryProvider);
  return repository.getBlockedProfiles(blockedProfiles);
}

//GET ACCOUNT PROFILES
@riverpod
Stream<QuerySnapshot<Map<String, dynamic>>> getAccountProfiles(GetAccountProfilesRef ref) {
  final repository = ref.watch(profileRepositoryProvider);
  return repository.getAccountProfiles();
}

@riverpod
Future<ModelProfile> getProfileFromPost(GetProfileFromPostRef ref, String profileUid) {
  final repository = ref.watch(profileRepositoryProvider);
  return repository.getProfileFromPost(profileUid);
}

//USER REPOSITORY PROVIDER
// @Riverpod(keepAlive: true)
// UserProvider user(UserRef ref) {
//   return UserProvider(
//     authRepository: ref.read(authRepositoryProvider),
//     profileRepository: ref.read(profileRepositoryProvider),
//   );
// }

final userProvider = StateNotifierProvider<UserProvider, ModelProfile?>((ref) {
  return UserProvider(
    authRepository: ref.watch(authRepositoryProvider),
    profileRepository: ref.watch(profileRepositoryProvider),
  );
});

class UserProvider extends StateNotifier<ModelProfile?> {
  final AuthRepository _authRepository;
  final ProfileRepository _profileRepository;
  UserProvider({
    required AuthRepository authRepository,
    required ProfileRepository profileRepository,
  })  : _authRepository = authRepository,
        _profileRepository = profileRepository,
        super(null);

  //UserProvider() : super(null);

  // REFRESH PROFILE
  Future<void> refreshProfile({String? profileUid}) async {
    ModelProfile profile = await _authRepository.getProfileDetails(profileUid ?? state?.profileUid);
    state = profile;
  }

  // DISPOSE PROFILE
  void disposeProfile() {
    state = null;
  }

  //UPDATE BLOCKED PROFILES ON FIRESTORE
  Future<void> updateBlockedProfiles(String blockedId) async {
    if (state != null) {
      await _profileRepository.blockUser(state!.profileUid, blockedId);
      state = state!.copyWith(blockedUsers: state!.blockedUsers);
    }
  }

  // UNBLOCK PROFILE
  void unblockProfile(String blockedId) async {
    if (state != null) {
      state!.blockedUsers.remove(blockedId);
      await updateBlockedProfiles(blockedId);
    }
  }

  // BLOCK PROFILE
  void blockProfile(String blockedId) async {
    if (state != null) {
      state!.blockedUsers.add(blockedId);
      await updateBlockedProfiles(blockedId);
    }
  }

  //UPDATE FOLLOWING/FOLLOWERS ON FIRESTORE
  Future<void> updateFollowProfiles(String profileUid, String followId) async {
    if (state != null) {
      await _profileRepository.followUser(state!.profileUid, followId);
      state = state!.copyWith(following: state!.following);
      state = state!.copyWith(followers: state!.followers);
    }
  }
}
