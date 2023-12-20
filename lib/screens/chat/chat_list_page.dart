import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pets_social/features/app_router.dart';
import 'package:pets_social/providers/chat/chat_provider.dart';
import 'package:pets_social/providers/user/user_provider.dart';

import '../../models/profile.dart';

class ChatList extends ConsumerStatefulWidget {
  const ChatList({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatListState();
}

class _ChatListState extends ConsumerState<ChatList> {
  bool isShowUsers = false;
  final TextEditingController searchController = TextEditingController();
  List<ModelProfile> profiles = [];
  List<ModelProfile> profilesFiltered = [];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final ModelProfile? profile = ref.read(userProvider);
      QuerySnapshot<Map<String, dynamic>> usersSnapshot = await FirebaseFirestore.instance.collectionGroup('profiles').where('profileUid', whereIn: profile!.following).get();

      for (QueryDocumentSnapshot doc in usersSnapshot.docs) {
        ModelProfile profile = ModelProfile.fromSnap(doc);

        profiles.add(profile);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final ModelProfile? profile = ref.watch(userProvider);
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        title: TextFormField(
          controller: searchController,
          decoration: InputDecoration(
            labelText: 'Search for user',
            labelStyle: TextStyle(color: theme.colorScheme.secondary),
          ),
          onChanged: (value) {
            setState(
              () {
                isShowUsers = true;
                profilesFiltered = profiles.where((element) => element.username.toLowerCase().contains(value.toLowerCase())).toList();
              },
            );
          },
        ),
      ),
      body: isShowUsers
          ? ListView.builder(
              itemCount: profilesFiltered.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    context.goNamed(AppRouter.chatPage.name, pathParameters: {
                      'receiverUserEmail': profilesFiltered[index].email,
                      'receiverUserId': profilesFiltered[index].profileUid,
                      'receiverUsername': profilesFiltered[index].username,
                    });
                  },
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(profilesFiltered[index].photoUrl!),
                    ),
                    title: Text(profilesFiltered[index].username),
                  ),
                );
              },
            )
          : profile!.following.isEmpty
              ? const Center(child: Text('Follow someone to start chatting!'))
              : _buildUserList(),
    );
  }

  //PROFILES LIST
  Widget _buildUserList() {
    final ModelProfile? profile = ref.watch(userProvider);
    final ThemeData theme = Theme.of(context);
    final chatsList = ref.watch(getChatsListProvider(profile));

    return chatsList.when(
      loading: () => LinearProgressIndicator(
        color: theme.colorScheme.secondary,
      ),
      error: (error, stackTrace) => Text('Error: $error'),
      data: (chats) {
        if (chats.isEmpty) {
          return const Center(
            child: Text('No chats found.'),
          );
        }
        return ListView(
          children: chats.map<Widget>((chats) => _buildUserListItem(chats)).toList(),
        );
      },
    );
  }

  String cropMessage(String message, int maxLetters) {
    if (message.length <= maxLetters) {
      return message;
    } else {
      return message.substring(0, maxLetters) + '...';
    }
  }

  //PROFILES LIST ITEMS
  Widget _buildUserListItem(
    DocumentSnapshot document,
  ) {
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
    final ModelProfile? profile = ref.watch(userProvider);
    final ThemeData theme = Theme.of(context);
    final lastMessages = ref.watch(getLastMessageProvider(profile!.profileUid, data['profileUid']));

    return lastMessages.when(
      error: (error, stacktrace) => Text('Error: $error'),
      loading: () => LinearProgressIndicator(
        color: theme.colorScheme.secondary,
      ),
      data: (lastMessages) {
        bool hasUnreadMessages = lastMessages.any((lastMessage) => !lastMessage['read']);
        String message = lastMessages.isNotEmpty ? lastMessages[0]['message'] : '';
        String croppedMessage = cropMessage(message, 25);

        if (profile.profileUid != data['profileUid']) {
          return ListTile(
            leading: CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(data['photoUrl'] ?? ""),
            ),
            title: hasUnreadMessages
                ? Text(
                    data['username'],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  )
                : Text(data['username']),
            subtitle: Text(
              croppedMessage,
              //style: hasUnreadMessages ? const TextStyle(fontWeight: FontWeight.bold) : null,
            ),
            trailing: hasUnreadMessages
                ? Icon(
                    Icons.fiber_manual_record,
                    size: 20,
                    color: theme.colorScheme.secondary,
                  )
                : null,
            onTap: () {
              context.goNamed(AppRouter.chatPage.name, pathParameters: {
                'receiverUserEmail': data['email'],
                'receiverUserId': data['profileUid'],
                'receiverUsername': data['username'],
              });
            },
          );
        } else {
          // Return empty container for the current user
          return Container();
        }
      },
    );
  }
}
