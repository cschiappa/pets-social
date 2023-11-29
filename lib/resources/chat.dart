import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pets_social/models/chatRoom.dart';
import 'package:pets_social/models/message.dart';
import 'package:provider/provider.dart';

import '../models/profile.dart';
import '../providers/user_provider.dart';

class ChatService extends ChangeNotifier {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  //SEND MESSAGE
  Future<String> sendMessage(String receiverUid, String receiverUsername,
      String message, context) async {
    final ModelProfile? profile =
        Provider.of<UserProvider>(context, listen: false).getProfile;
    String res = "An error occurred";
    try {
      final Timestamp timestamp = Timestamp.now();

      ModelChatRoom chatRoom = ModelChatRoom(
          users: [profile!.profileUid, receiverUid], lastMessage: null);

      ModelMessage newMessage = ModelMessage(
        senderUid: profile.profileUid,
        receiverUid: receiverUid,
        timestamp: timestamp,
        message: message,
        senderUsername: profile.username,
        receiverUsername: receiverUsername,
        read: false,
      );

      //CHAT ROOM ID
      List<String> ids = [profile.profileUid, receiverUid];
      ids.sort();
      String chatRoomId = ids.join("_"); //COMBINE IDS

      //CREATE COLLECTION
      final batch = firestore.batch();
      var chatRoomCollection = firestore.collection('chats').doc(chatRoomId);
      batch.set(chatRoomCollection, chatRoom.toJson());

      var messageCollection = firestore
          .collection('chats')
          .doc(chatRoomId)
          .collection('messages')
          .doc();

      batch.set(messageCollection, newMessage.toJson());

      await batch.commit();

      //GET LAST MESSAGE
      final lastMessageQuery = await firestore
          .collection('chats')
          .doc(chatRoomId)
          .collection('messages')
          .orderBy('timestamp', descending: true)
          .get();

      //SAVE USERS AND LAST MESSAGE TO CHAT ROOM ID
      if (lastMessageQuery.docs.isNotEmpty) {
        final lastMessage = lastMessageQuery.docs.first.data();
        await firestore.collection('chats').doc(chatRoomId).update(
          {
            "lastMessage": lastMessage,
          },
        );
      }

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

    return firestore
        .collection('chats')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }
}
