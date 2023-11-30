import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pets_social/features/app_router.dart';
import 'package:pets_social/models/chatRoom.dart';

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
      final ModelProfile? profile =
          Provider.of<UserProvider>(context, listen: false).getProfile;
      QuerySnapshot<Map<String, dynamic>> usersSnapshot =
          await FirebaseFirestore.instance
              .collectionGroup('profiles')
              .where('profileUid', whereIn: profile!.following)
              .get();

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
                profilesFiltered = profiles
                    .where((element) => element.username
                        .toLowerCase()
                        .contains(value.toLowerCase()))
                    .toList();
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
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => ChatPage(
                    //       receiverUserEmail: profilesFiltered[index].email,
                    //       receiverUserID: profilesFiltered[index].profileUid,
                    //       receiverUsername: profilesFiltered[index].username,
                    //     ),
                    //   ),
                    // );
                    context.goNamed(AppRouter.chatPage.name, pathParameters: {
                      'receiverUserEmail': profilesFiltered[index].email,
                      'receiverUserId': profilesFiltered[index].profileUid,
                      'receiverUsername': profilesFiltered[index].username,
                    });
                  },
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage:
                          NetworkImage(profilesFiltered[index].photoUrl!),
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

  Widget _buildUserList() {
    final ModelProfile? profile = Provider.of<UserProvider>(context).getProfile;
    final ThemeData theme = Theme.of(context);

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('chats')
          .orderBy('lastMessage.timestamp', descending: true)
          .where('users', arrayContains: profile!.profileUid)
          .snapshots(),
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

          // Retrieve the 'lastMessage' field
          //Map<String, dynamic>? lastMessageMap = doc['lastMessage'];

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

            List<DocumentSnapshot> profileDocs =
                profileSnapshot.data as List<DocumentSnapshot>;

            return ListView(
              children: profileDocs
                  .map<Widget>((profileDocs) => _buildUserListItem(profileDocs))
                  .toList(),
            );
          },
        );
      },
    );
  }

  Future<List<DocumentSnapshot>> _fetchProfiles(
      List<String> profileUidList) async {
    List<Future<DocumentSnapshot>> futures = profileUidList.map(
      (profileUid) {
        return FirebaseFirestore.instance
            .collectionGroup('profiles')
            .where('profileUid', isEqualTo: profileUid)
            .get()
            .then((querySnapshot) => querySnapshot.docs.first);
      },
    ).toList();

    return await Future.wait(futures);
  }

  //build a list of profiles
  // Widget _buildUserList() {
  //   final ModelProfile? profile = Provider.of<UserProvider>(context).getProfile;
  //   final ThemeData theme = Theme.of(context);

  //      FirebaseFirestore.instance
  //         .collection('chats')
  //         .where('users', arrayContains: profile!.profileUid)
  //         .orderBy('timestamp', descending: true)
  //         .snapshots()
  //         .asyncMap((querySnapshot) async {
  //       // Get the list of profile UIDs different from the current profile
  //       List<String> profileUidList = [];
  //       for (var doc in querySnapshot.docs) {
  //         List<dynamic> users = doc['users'];
  //         for (var profileUid in users) {
  //           if (profileUid != profile.profileUid) {
  //             profileUidList.add(profileUid);
  //           }
  //         }
  //       }

  //       // Step 2: Fetch corresponding profiles from the 'profiles' collection group
  //       await Future.wait(
  //         profileUidList.map(
  //           (profileUid) async {
  //             var profileDocs = await FirebaseFirestore.instance
  //                 .collectionGroup('profiles')
  //                 .where('profileUid', isEqualTo: profileUid)
  //                 .get();

  //           },
  //         ),
  //       );
  //     });

  //   return StreamBuilder<QuerySnapshot>(
  //     stream: profileDocs,
  //     builder: (context, snapshot){
  //       if (snapshot.hasError) {
  //         return const Text('error');
  //       }

  //       if (snapshot.connectionState == ConnectionState.waiting) {
  //         return LinearProgressIndicator(
  //           color: theme.colorScheme.secondary,
  //         );
  //       }

  //       return ListView(
  //         children: snapshot.data!.docs
  //             .map<Widget>((doc) => _buildUserListItem(doc))
  //             .toList(),
  //       );
  //     });

  //   // return StreamBuilder<QuerySnapshot>(
  //   //   stream: FirebaseFirestore.instance
  //   //       .collectionGroup('profiles')
  //   //       .where('profileUid', whereIn: profile!.following)
  //   //       .snapshots(),
  //   //   builder: (context, snapshot) {
  //   //     if (snapshot.hasError) {
  //   //       return const Text('error');
  //   //     }

  //   //     if (snapshot.connectionState == ConnectionState.waiting) {
  //   //       return LinearProgressIndicator(
  //   //         color: theme.colorScheme.secondary,
  //   //       );
  //   //     }

  //   //     return ListView(
  //   //       children: snapshot.data!.docs
  //   //           .map<Widget>((doc) => _buildUserListItem(doc))
  //   //           .toList(),
  //   //     );
  //   //   },
  //   // );
  // }

  //build individual user list items
  Widget _buildUserListItem(
    DocumentSnapshot document,
  ) {
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
    final ModelProfile? profile = Provider.of<UserProvider>(context).getProfile;
    final ThemeData theme = Theme.of(context);

    //display all users except current user
    if (profile!.profileUid != data['profileUid']) {
      return ListTile(
        leading: CircleAvatar(
          radius: 15,
          backgroundImage: NetworkImage(data['photoUrl'] ?? ""),
        ),
        title: Text(data['username']),
        trailing: Icon(
          Icons.mark_chat_unread,
          size: 20,
          color: theme.colorScheme.secondary,
        ),
        onTap: () {
          //enter chat page when clicked
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => ChatPage(
          //       receiverUserEmail: data['email'],
          //       receiverUserID: data['profileUid'],
          //       receiverUsername: data['username'],
          //     ),
          //   ),
          // );
          context.goNamed(AppRouter.chatPage.name, pathParameters: {
            'receiverUserEmail': data['email'],
            'receiverUserId': data['profileUid'],
            'receiverUsername': data['username'],
          });
        },
      );
    } else {
      //return empty container
      return Container();
    }
  }
}
