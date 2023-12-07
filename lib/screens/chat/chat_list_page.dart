import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pets_social/features/app_router.dart';
import 'package:provider/provider.dart';
import '../../models/profile.dart';
import '../../providers/user_provider.dart';

class ChatList extends StatefulWidget {
  const ChatList({super.key});

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  bool isShowUsers = false;
  final TextEditingController searchController = TextEditingController();
  List<ModelProfile> profiles = [];
  List<ModelProfile> profilesFiltered = [];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final ModelProfile? profile = Provider.of<UserProvider>(context, listen: false).getProfile;
      QuerySnapshot<Map<String, dynamic>> usersSnapshot = await FirebaseFirestore.instance.collectionGroup('profiles').where('profileUid', whereIn: profile!.following).get();

      for (QueryDocumentSnapshot doc in usersSnapshot.docs) {
        ModelProfile profile = ModelProfile.fromSnap(doc);

        profiles.add(profile);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final ModelProfile? profile = Provider.of<UserProvider>(context).getProfile;
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
    final ModelProfile? profile = Provider.of<UserProvider>(context).getProfile;
    final ThemeData theme = Theme.of(context);

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('chats').orderBy('lastMessage.timestamp', descending: true).where('users', arrayContains: profile!.profileUid).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Error');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return LinearProgressIndicator(
            color: theme.colorScheme.secondary,
          );
        }

        List<String> profileUidList = [];

        for (var doc in snapshot.data!.docs) {
          List<dynamic> users = doc['users'];

          for (var profileUid in users) {
            if (profileUid != profile.profileUid) {
              profileUidList.add(profileUid);
            }
          }
        }

        return FutureBuilder(
          future: _fetchProfiles(
            profileUidList,
          ),
          builder: (context, profileSnapshot) {
            if (profileSnapshot.connectionState == ConnectionState.waiting) {
              return LinearProgressIndicator(
                color: theme.colorScheme.secondary,
              );
            }

            if (profileSnapshot.hasError) {
              return const Text('Error fetching profiles');
            }

            List<DocumentSnapshot> profileDocs = profileSnapshot.data as List<DocumentSnapshot>;

            return ListView(
              children: profileDocs.map<Widget>((profileDocs) => _buildUserListItem(profileDocs)).toList(),
            );
          },
        );
      },
    );
  }

  //FETCH PROFILES
  Future<List<DocumentSnapshot>> _fetchProfiles(List<String> profileUidList) async {
    List<Future<DocumentSnapshot>> futures = profileUidList.map(
      (profileUid) {
        return FirebaseFirestore.instance.collectionGroup('profiles').where('profileUid', isEqualTo: profileUid).get().then((querySnapshot) => querySnapshot.docs.first);
      },
    ).toList();

    return await Future.wait(futures);
  }

  //CHECK UNREAD MESSAGES
  Future<List<Map<String, dynamic>>> checkReads(String receiverUid, String senderUid) async {
    final QuerySnapshot messages = await FirebaseFirestore.instance.collection('chats').where('lastMessage.receiverUid', isEqualTo: receiverUid).where('lastMessage.senderUid', isEqualTo: senderUid).get();

    return messages.docs.map((doc) => doc['lastMessage'] as Map<String, dynamic>).toList();
  }

  //PROFILES LIST ITEMS
  Widget _buildUserListItem(
    DocumentSnapshot document,
  ) {
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
    final ModelProfile? profile = Provider.of<UserProvider>(context).getProfile;
    final ThemeData theme = Theme.of(context);

    return FutureBuilder<List<Map<String, dynamic>>>(
      future: checkReads(profile!.profileUid, data['profileUid']),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return LinearProgressIndicator(
            color: theme.colorScheme.secondary,
          );
        }

        if (snapshot.hasError) {
          return const Text('Error checking unread messages');
        }

        List<Map<String, dynamic>> lastMessages = snapshot.data ?? [];

        bool hasUnreadMessages = lastMessages.any((lastMessage) => !lastMessage['read']);
        String message = lastMessages.isNotEmpty ? lastMessages[0]['message'] : '';

        // Display all users except the current user
        if (profile.profileUid != data['profileUid']) {
          return ListTile(
            leading: CircleAvatar(
              radius: 15,
              backgroundImage: NetworkImage(data['photoUrl'] ?? ""),
            ),
            title: hasUnreadMessages
                ? Text(
                    data['username'],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  )
                : Text(data['username']),
            subtitle: hasUnreadMessages
                ? Text(
                    message,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  )
                : null,
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
