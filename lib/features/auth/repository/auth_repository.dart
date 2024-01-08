import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pets_social/core/utils.dart';
import 'package:pets_social/models/account.dart';
import 'package:pets_social/models/profile.dart';
import 'package:pets_social/core/constants/firebase_constants.dart';
import 'package:pets_social/core/providers/storage_methods.dart';
import 'package:pets_social/router.dart';
import 'package:uuid/uuid.dart';
import '../../notification/repository/notification_repository.dart';

class AuthRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final StorageRepository _storageRepository;
  final NotificationRepository _notificationRepository;
  AuthRepository({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
    required StorageRepository storageRepository,
    required NotificationRepository notificationRepository,
  })  : _auth = auth,
        _firestore = firestore,
        _storageRepository = storageRepository,
        _notificationRepository = notificationRepository;

  //GET AUTHENTICATION CHANGES
  Stream<User?> get authStateChange => _auth.authStateChanges();

  //GET PROFILE DETAILS
  Future<ModelProfile> getProfileDetails(String? profileUid) async {
    User currentUser = _auth.currentUser!;
    DocumentSnapshot snap;

    if (profileUid != null) {
      final String profilePath = FirestorePath.profile(currentUser.uid, profileUid);
      snap = await _firestore.doc(profilePath).get();
    } else {
      QuerySnapshot querySnapshot = await _firestore.collection('users').doc(currentUser.uid).collection('profiles').limit(1).get();

      if (querySnapshot.docs.isNotEmpty) {
        snap = querySnapshot.docs.first;
      } else {
        throw Exception('No profiles found.');
      }
    }
    return ModelProfile.fromSnap(snap);
  }

  //SIGN UP
  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    String? bio,
    Uint8List? file,
    String? photoUrl,
  }) async {
    String res = "Some error occurred";
    try {
      if (isPasswordValid(password)) {
        if (email.isNotEmpty && password.isNotEmpty && username.isNotEmpty) {
          if (username.length <= 15 && bio!.length <= 150) {
            //register user
            UserCredential cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);

            if (file != null) {
              photoUrl = await _storageRepository.uploadImageToStorage('profilePics', file, false);
            } else {
              photoUrl = 'https://i.pinimg.com/474x/eb/bb/b4/ebbbb41de744b5ee43107b25bd27c753.jpg';
            }

            ModelAccount account = ModelAccount(email: email, uid: cred.user!.uid);

            String profileUid = const Uuid().v1(); //v1 creates unique id based on time
            ModelProfile profile = ModelProfile(
              username: username,
              profileUid: profileUid,
              email: email,
              bio: bio,
              photoUrl: photoUrl,
              following: [],
              followers: [],
              savedPost: [],
              blockedUsers: [],
            );

            final String userPath = FirestorePath.user(cred.user!.uid);
            final String profilePath = FirestorePath.profile(cred.user!.uid, profileUid);

            final batch = _firestore.batch();
            var accountCollection = _firestore.doc(userPath);
            batch.set(accountCollection, account.toJson());

            var profileCollection = _firestore.doc(profilePath);

            batch.set(profileCollection, profile.toJson());

            await batch.commit();

            //FirebaseApi().initNotifications();
            res = "success";
          } else {
            res = "Username must be 30 characters or less and bio must be 150 characters or less.";
          }
        } else {
          res = "You must choose an email and password.";
        }
      } else {
        res = "Your password must contain a minimum of 5 letters, at least 1 upper case letter, 1 lower case letter, 1 numeric character and one special character.";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  //LOG IN
  Future<String> loginUser({required String email, required String password}) async {
    String res = "An error occurred";

    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(email: email, password: password);

        _notificationRepository.initNotifications();
        res = "success";
      } else {
        res = "Please enter a valid email and password.";
      }
    } catch (err) {
      res = "Incorrect email or password. Please try again.";
    }
    return res;
  }

  //SIGN OUT
  Future<void> signOut(context) async {
    await _notificationRepository.removeTokenFromDatabase().then((value) => _auth.signOut());
  }

  //DELETE ACCOUNT
  Future<void> deleteUserAccount(context) async {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        final userPath = FirestorePath.user(user.uid);
        // Delete the user's account from Firebase Authentication
        await user.delete();

        //Delete the user's account from Firestore collection
        await _firestore.doc(userPath).delete();

        context.goNamed(AppRouter.login.name);
      } catch (e) {
        debugPrint('Error deleting account: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('There was an error deleting the account.'),
          ),
        );
      }
    }
  }

  //CHANGE PASSWORD
  Future<void> changePassword(BuildContext context, String newPassword) async {
    final User? user = FirebaseAuth.instance.currentUser;
    try {
      if (isPasswordValid(newPassword)) {
        await user!.updatePassword(newPassword);

        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Your password has been changed.'),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('There was an error updating the password.'),
        ),
      );
      debugPrint('There was an error updating the password.');
    }
  }

  //AUTHENTICATION
  Future<bool> verifyCurrentPassword(String currentPassword) async {
    final User? user = FirebaseAuth.instance.currentUser;

    AuthCredential credential = EmailAuthProvider.credential(email: user!.email!, password: currentPassword);

    try {
      await user.reauthenticateWithCredential(credential);
      return true;
    } catch (e) {
      debugPrint('current password is incorrect');
      return false;
    }
  }
}