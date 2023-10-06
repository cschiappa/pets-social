import 'package:flutter/material.dart';
import 'package:pets_social/models/profile.dart';
import 'package:pets_social/resources/auth_methods.dart';

class UserProvider with ChangeNotifier {
  ModelProfile? _profile;
  final AuthMethods _authMethods = AuthMethods();

  ModelProfile? get getProfile => _profile;

  Future<void> refreshProfile({String? profileUid}) async {
    ModelProfile profile = await _authMethods
        .getProfileDetails(profileUid ?? _profile?.profileUid);
    _profile = profile;
    notifyListeners();
  }

  disposeProfile() {
    _profile = null;
  }

  // Method to unblock a profile by their UID
  void unblockUser(String profileUid) {
    if (_profile != null) {
      _profile!.blockedUsers.remove(profileUid);

      notifyListeners();
    }
  }
}
