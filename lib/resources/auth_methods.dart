import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pets_social/models/user.dart' as model;
import 'package:pets_social/resources/storage_methods.dart';
import 'package:pets_social/screens/initial_screen/login_screen.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot snap =
        await _firestore.collection('users').doc(currentUser.uid).get();
    return model.User.fromSnap(snap);
  }

  //Checks if password follows all the requirement
  bool isPasswordValid(String password) {
    final lengthRequirement = 5;
    final uppercaseRegex = RegExp(r'[A-Z]');
    final lowercaseRegex = RegExp(r'[a-z]');
    final numberRegex = RegExp(r'[0-9]');
    final specialCharacterRegex = RegExp(r'[!@#$%^&*()_+{}\[\]:;<>,.?~\\-]');

    if (password.length < lengthRequirement ||
        !uppercaseRegex.hasMatch(password) ||
        !lowercaseRegex.hasMatch(password) ||
        !numberRegex.hasMatch(password) ||
        !specialCharacterRegex.hasMatch(password)) {
      return false;
    }

    return true;
  }

  //sign up user
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
          //register user
          UserCredential cred = await _auth.createUserWithEmailAndPassword(
              email: email, password: password);

          if (file != null) {
            photoUrl = await StorageMethods()
                .uploadImageToStorage('profilePics', file, false);
          } else {
            photoUrl =
                'https://i.pinimg.com/474x/eb/bb/b4/ebbbb41de744b5ee43107b25bd27c753.jpg';
          }

          //add user to database

          model.User user = model.User(
            username: username,
            uid: cred.user!.uid,
            email: email,
            bio: bio ?? "",
            photoUrl: photoUrl ??
                'https://i.pinimg.com/474x/eb/bb/b4/ebbbb41de744b5ee43107b25bd27c753.jpg',
            following: [],
            followers: [],
            savedPost: [],
            blockedUsers: [],
          );

          await _firestore.collection('users').doc(cred.user!.uid).set(
                user.toJson(),
              );
          res = "success";
        }
      } else {
        res =
            "Your password must contain a minimum of 5 letters, at least 1 upper case letter, 1 lower case letter, 1 numeric character and one special character.";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  //log in user
  Future<String> loginUser(
      {required String email, required String password}) async {
    String res = "An error occurred";

    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = "success";
      } else {
        res = "Please enter all the fields";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  //Sign Out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  //Delete User
  Future<void> deleteUserAccount(context) async {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        // user.reauthenticateWithCredential()
        // Delete the user's account from Firebase Authentication
        await user.delete();

        //Delete the user's account from Firestore collection
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .delete();

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ),
        );
      } catch (e) {
        // Handle any errors that may occur during deletion
        print('Error deleting account: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('There was an error deleting the account.'),
          ),
        );
      }
    }
  }

  //Change password
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
      print('There was an error updating the password.');
    }
  }

  //Verify Current Password
  Future<bool> verifyCurrentPassword(String currentPassword) async {
    final User? user = FirebaseAuth.instance.currentUser;

    AuthCredential credential = EmailAuthProvider.credential(
        email: user!.email!, password: currentPassword);

    try {
      await user.reauthenticateWithCredential(credential);
      return true;
    } catch (e) {
      print('current password is incorrect');
      return false;
    }
  }
}
