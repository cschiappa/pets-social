import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pets_social/providers/profile/profile_provider.dart';
import 'package:pets_social/providers/user/user_provider.dart';

import 'package:pets_social/models/profile.dart';

import '../../services/firestore_methods.dart';

class BlockedAccountsPage extends ConsumerStatefulWidget {
  const BlockedAccountsPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BlockedAccountsPageState();
}

class _BlockedAccountsPageState extends ConsumerState<BlockedAccountsPage> {
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

  //BLOCKED PROFILES LIST
  Widget _buildUserList() {
    final ModelProfile? profile = ref.watch(userProvider).getProfile;
    final blockedAccountsState = ref.watch(getBlockedProfilesProvider(profile));
    final ThemeData theme = Theme.of(context);
    return blockedAccountsState.when(
      loading: () => LinearProgressIndicator(
        color: theme.colorScheme.secondary,
      ),
      error: (error, stackTrace) => Text('Error: $error'),
      data: (blockedAccounts) {
        if (blockedAccounts.isEmpty) {
          return const Center(
            child: Text('No users blocked.'),
          );
        }

        return ListView(
          children: blockedAccounts.map<Widget>((blockedAccount) => _buildUserListItem(blockedAccount)).toList(),
        );
      },
    );
  }

  //BLOCKED PROFILES LIST ITEMS
  Widget _buildUserListItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
    final ModelProfile? profile = ref.watch(userProvider).getProfile;
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

            ref.watch(userProvider).unblockProfile(data['profileUid']);
          },
          child: const Text('Unblock'),
        ));
  }
}
