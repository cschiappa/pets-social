import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pets_social/providers/user_provider.dart';
import 'package:pets_social/utils/colors.dart';
import 'package:provider/provider.dart';
import 'package:pets_social/models/user.dart' as model;

import '../resources/firestore_methods.dart';

class BlockedAccountsPage extends StatefulWidget {
  const BlockedAccountsPage({super.key});

  @override
  State<BlockedAccountsPage> createState() => _BlockedAccountsPageState();
}

class _BlockedAccountsPageState extends State<BlockedAccountsPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mobileBackgroundColor,
      appBar: AppBar(
        title: Text('Blocked Accounts'),
      ),
      body: _buildUserList(),
    );
  }

  //build a list of users except for the one logged in
  Widget _buildUserList() {
    final model.User? user = Provider.of<UserProvider>(context).getUser;

    return user!.blockedUsers.isNotEmpty
        ? StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .where('uid', whereIn: user.blockedUsers)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Text('error');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Text('loading...');
              }

              return ListView(
                children: snapshot.data!.docs
                    .map<Widget>((doc) => _buildUserListItem(doc))
                    .toList(),
              );
            },
          )
        : Center(
            child: Text('No users blocked.'),
          );
  }

  //build individual user list items
  Widget _buildUserListItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
    final model.User? user = Provider.of<UserProvider>(context).getUser;
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    //display all users except current user
    return ListTile(
        leading: CircleAvatar(
          radius: 15,
          backgroundImage: NetworkImage(data['photoUrl']),
        ),
        title: Text(data['username']),
        trailing: TextButton(
          onPressed: () async {
            await FirestoreMethods().blockUser(user!.uid, data['uid']);

            userProvider.unblockUser(data['uid']);
          },
          child: Text('Unblock'),
        ));
  }
}
