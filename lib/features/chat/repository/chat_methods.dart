import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pets_social/models/chat_room.dart';
import 'package:pets_social/models/message.dart';
import 'package:pets_social/core/constants/firebase_constants.dart';

import '../../../models/profile.dart';

class ChatRepository {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  //SEND MESSAGE
  Future<String> sendMessage(String receiverUid, String receiverUsername, String message, BuildContext context, ModelProfile? profile) async {
    String res = "An error occurred";
    try {
      final Timestamp timestamp = Timestamp.now();

      ModelChatRoom chatRoom = ModelChatRoom(users: [profile!.profileUid, receiverUid], lastMessage: null);

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
      //PATH
      final String chatPath = FirestorePath.chat(chatRoomId);

      batch.set(firestore.doc(chatPath), chatRoom.toJson());

      var messageCollection = firestore.doc(chatPath).collection('messages').doc();

      batch.set(messageCollection, newMessage.toJson());

      await batch.commit();

      //GET LAST MESSAGE
      final lastMessageQuery = await firestore.doc(chatPath).collection('messages').orderBy('timestamp', descending: true).get();

      //SAVE USERS AND LAST MESSAGE TO CHAT ROOM ID
      if (lastMessageQuery.docs.isNotEmpty) {
        final lastMessage = lastMessageQuery.docs.first.data();
        await firestore.doc(chatPath).update(
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
    final String chatPath = FirestorePath.chat(chatRoomId);

    return firestore.doc(chatPath).collection('messages').orderBy('timestamp', descending: true).snapshots();
  }

  //UPDATE MESSAGE READ VALUE
  Future<void> messageRead(String profileUid, String receiverUiD) async {
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('chats').where('lastMessage.receiverUid', isEqualTo: profileUid).where('lastMessage.senderUid', isEqualTo: receiverUiD).where('lastMessage.read', isEqualTo: false).get();

    if (querySnapshot.docs.isNotEmpty) {
      await querySnapshot.docs.first.reference.update({
        'lastMessage': {
          ...querySnapshot.docs.first['lastMessage'],
          'read': true,
        },
      });
    }
  }

  //CHECK UNREAD MESSAGES
  Stream<List<Map<String, dynamic>>> getLastMessage(String receiverUid, String senderUid) {
    final Query<Map<String, dynamic>> query = FirebaseFirestore.instance.collection('chats').where('lastMessage.receiverUid', isEqualTo: receiverUid).where('lastMessage.senderUid', isEqualTo: senderUid);

    return query.snapshots().map((querySnapshot) {
      return querySnapshot.docs.map((doc) => doc['lastMessage'] as Map<String, dynamic>).toList();
    });
  }

  //GET NUMBER OF CHATS
  Stream<int> numberOfUnreadChats(String profileUid) {
    final Query<Map<String, dynamic>> query = FirebaseFirestore.instance.collection('chats').where('lastMessage.receiverUid', isEqualTo: profileUid).where('lastMessage.read', isEqualTo: false);

    return query.snapshots().map((querySnapshot) {
      return querySnapshot.docs.length;
    });
  }

  //GET CHAT LIST
  Future<List<DocumentSnapshot>> getChatsList(ModelProfile? profile) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance.collection('chats').orderBy('lastMessage.timestamp', descending: true).where('users', arrayContains: profile!.profileUid).get();

    List<String> profileUidList = [];

    for (var doc in snapshot.docs) {
      List<dynamic> users = doc['users'];

      for (var profileUid in users) {
        if (profileUid != profile.profileUid) {
          profileUidList.add(profileUid);
        }
      }
    }

    List<Future<DocumentSnapshot>> futures = profileUidList.map(
      (profileUid) {
        return FirebaseFirestore.instance.collectionGroup('profiles').where('profileUid', isEqualTo: profileUid).get().then((querySnapshot) => querySnapshot.docs.first);
      },
    ).toList();

    return await Future.wait(futures);
  }
}
