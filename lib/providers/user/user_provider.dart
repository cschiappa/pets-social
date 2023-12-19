import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pets_social/models/profile.dart';
import 'package:pets_social/providers/post/post_provider.dart';
import 'package:pets_social/services/auth_methods.dart';
import 'package:pets_social/services/firestore_methods.dart';

class UserProvider extends StateNotifier<ModelProfile?> {
  final AuthMethods _authMethods = AuthMethods();

  UserProvider() : super(null);

  // REFRESH PROFILE
  Future<void> refreshProfile({String? profileUid}) async {
    ModelProfile profile = await _authMethods.getProfileDetails(profileUid ?? state?.profileUid);
    state = profile;
  }

  // DISPOSE PROFILE
  void disposeProfile() {
    state = null;
  }

  //UPDATE BLOCKED PROFILES ON FIRESTORE
  Future<void> updateBlockedProfiles(String blockedId) async {
    if (state != null) {
      await FirestoreMethods().blockUser(state!.profileUid, blockedId);
      state = state!.copyWith(blockedUsers: state!.blockedUsers);
    }
  }

  // // UNBLOCK PROFILE
  void unblockProfile(String blockedId) async {
    if (state != null) {
      state!.blockedUsers.remove(blockedId);
      await updateBlockedProfiles(blockedId);
    }
  }

  // // BLOCK PROFILE
  void blockProfile(String blockedId) async {
    if (state != null) {
      state!.blockedUsers.add(blockedId);
      await updateBlockedProfiles(blockedId);
    }
  }
}

final userProvider = StateNotifierProvider<UserProvider, ModelProfile?>((ref) {
  return UserProvider();
});

// part 'user_provider.g.dart';

// @Riverpod(keepAlive: true)
// UserProvider user(UserRef ref) {
//   return UserProvider();
// }

// class UserProvider extends ChangeNotifier {
//   ModelProfile? _profile;
//   final AuthMethods _authMethods = AuthMethods();

//   ModelProfile? get getProfile => _profile;

//   //REFRESH PROFILE
//   Future<void> refreshProfile({String? profileUid}) async {
//     ModelProfile profile = await _authMethods.getProfileDetails(profileUid ?? _profile?.profileUid);
//     _profile = profile;

//     notifyListeners();
//   }

//   //DISPOSE PROFILE
//   disposeProfile() {
//     _profile = null;
//   }

//   // //UNBLOCK PROFILE
//   // void unblockProfile(String profileUid) {
//   //   if (_profile != null) {
//   //     _profile!.blockedUsers.remove(profileUid);
//   //     notifyListeners();
//   //   }
//   // }

//   // //BLOCK PROFILE
//   // void blockProfile(String profileUid) {
//   //   if (_profile != null) {
//   //     _profile!.blockedUsers.add(profileUid);
//   //     notifyListeners();
//   //   }
//   // }
// }
