import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pets_social/models/message.dart';

class ChatService extends ChangeNotifier {
  //get instance of auth and firestore
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  //SEND MESSAGE
  Future<void> sendMessage(String receiverId, String message) async {
    //get current user info
    final String currentUserId = _fireStore
        .collection('users')
        .doc('uid')
        .collection('profiles')
        .doc('profileUid')
        .toString();
    final String currentUserEmail = _firebaseAuth.currentUser!.email.toString();
    final String currentUserUsername = _fireStore
        .collection('users')
        .doc('uid')
        .collection('profiles')
        .doc('username')
        .toString();
    final Timestamp timestamp = Timestamp.now();

    //create a new message
    ModelMessage newMessage = ModelMessage(
      senderId: currentUserId,
      senderEmail: currentUserEmail,
      receiverId: receiverId,
      timestamp: timestamp,
      message: message,
      senderUsername: currentUserUsername,
      receiverUsername: currentUserUsername,
    );

    //construct chat room id from current user id and receiver id and sort
    List<String> ids = [currentUserId, receiverId];
    ids.sort();
    String chatRoomId = ids.join("_"); //combine ids into a single string

    //add new message to database
    await _fireStore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .add(newMessage.toMap());
  }

  //GET MESSAGES
  Stream<QuerySnapshot> getMessages(String userId, String otherUserId) {
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join("_");

    return _fireStore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }
}
