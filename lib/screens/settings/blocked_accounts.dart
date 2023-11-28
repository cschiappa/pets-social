import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pets_social/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:pets_social/models/profile.dart';

import '../../resources/firestore_methods.dart';

class BlockedAccountsPage extends StatefulWidget {
  const BlockedAccountsPage({super.key});

  @override
  State<BlockedAccountsPage> createState() => _BlockedAccountsPageState();
}

class _BlockedAccountsPageState extends State<BlockedAccountsPage> {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.appBarTheme.backgroundColor,
      appBar: AppBar(
        title: const Text('Blocked Accounts'),
        backgroundColor: theme.colorScheme.background,
      ),
      body: _buildUserList(),
    );
  }

  //build a list of blocked users
  Widget _buildUserList() {
    final ModelProfile? profile = Provider.of<UserProvider>(context).getProfile;
    final ThemeData theme = Theme.of(context);
    return profile!.blockedUsers.isNotEmpty
        ? StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collectionGroup('profiles')
                .where('profileUid', whereIn: profile.blockedUsers)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Text('error');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return LinearProgressIndicator(
                  color: theme.colorScheme.secondary,
                );
              }

              return ListView(
                children: snapshot.data!.docs
                    .map<Widget>((doc) => _buildUserListItem(doc))
                    .toList(),
              );
            },
          )
        : const Center(
            child: Text('No users blocked.'),
          );
  }

  //build individual user list items
  Widget _buildUserListItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
    final ModelProfile? profile = Provider.of<UserProvider>(context).getProfile;
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
            await FirestoreMethods().blockUser(
              profile!.profileUid,
              data['profileUid'],
            );

            userProvider.unblockUser(data['profileUid']);
          },
          child: const Text('Unblock'),
        ));
  }
}
