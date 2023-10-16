import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pets_social/models/message.dart';
import 'package:provider/provider.dart';

import '../models/profile.dart';
import '../providers/user_provider.dart';

class ChatService extends ChangeNotifier {
  //get instance of auth and firestore
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  //SEND MESSAGE
  Future<String> sendMessage(String receiverUid, String receiverUsername,
      String message, context) async {
    final ModelProfile? profile =
        Provider.of<UserProvider>(context, listen: false).getProfile;
    String res = "An error occurred";
    try {
      final currentProfileEmail = _firebaseAuth.currentUser!.email.toString();

      final Timestamp timestamp = Timestamp.now();

      //create a new message
      ModelMessage newMessage = ModelMessage(
        senderUid: profile!.profileUid,
        senderEmail: currentProfileEmail,
        receiverUid: receiverUid,
        timestamp: timestamp,
        message: message,
        senderUsername: profile.username,
        receiverUsername: receiverUsername,
      );

      //construct chat room id from current user id and receiver id and sort
      List<String> ids = [profile.profileUid, receiverUid];
      ids.sort();
      String chatRoomId = ids.join("_"); //combine ids into a single string

      await _fireStore
          .collection('chats')
          .doc(chatRoomId)
          .collection('messages')
          .add(newMessage.toJson());

      res = "success";
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  //GET MESSAGES
  Stream<QuerySnapshot> getMessages(String userUid, String otherUserUid) {
    List<String> ids = [userUid, otherUserUid];
    ids.sort();
    String chatRoomId = ids.join("_");

    return _fireStore
        .collection('chats')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }
}
