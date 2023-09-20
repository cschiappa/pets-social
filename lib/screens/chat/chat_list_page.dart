import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pets_social/screens/chat/chat_page.dart';
import 'package:pets_social/utils/colors.dart';
import 'package:provider/provider.dart';

import '../../models/profile.dart';
import '../../providers/user_provider.dart';

class ChatList extends StatefulWidget {
  const ChatList({super.key});

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
        backgroundColor: Colors.black,
      ),
      body: _buildUserList(),
    );
  }

  //build a list of users except for the one logged in
  Widget _buildUserList() {
    final ModelProfile? profile = Provider.of<UserProvider>(context).getProfile;

    return StreamBuilder<QuerySnapshot>(
      stream:
          FirebaseFirestore.instance.collectionGroup('profiles').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('error');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: pinkColor),
          );
        }

        return ListView(
          children: snapshot.data!.docs
              .map<Widget>((doc) => _buildUserListItem(doc))
              .toList(),
        );
      },
    );
  }

  //build individual user list items
  Widget _buildUserListItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

    //display all users except current user
    if (_auth.currentUser!.uid != data['profileUid']) {
      return ListTile(
        leading: CircleAvatar(
          radius: 15,
          backgroundImage: NetworkImage(data['photoUrl'] ?? ""),
        ),
        title: Text(data['username']),
        onTap: () {
          //enter chat page when clicked
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(
                receiverUserEmail: data['email'],
                receiverUserID: data['profileUid'],
                receiverUsername: data['username'],
              ),
            ),
          );
        },
      );
    } else {
      //return empty container
      return Container();
    }
  }
}
