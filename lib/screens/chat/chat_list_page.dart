import 'package:cloud_firestore/cloud_firestore.dart';
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

    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: TextFormField(
          controller: searchController,
          decoration: const InputDecoration(
            labelText: 'Search for user',
            labelStyle: TextStyle(color: pinkColor),
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatPage(
                          receiverUserEmail: profilesFiltered[index].email,
                          receiverUserID: profilesFiltered[index].profileUid,
                          receiverUsername: profilesFiltered[index].username,
                        ),
                      ),
                    );
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

  //build a list of profiles
  Widget _buildUserList() {
    final ModelProfile? profile = Provider.of<UserProvider>(context).getProfile;

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collectionGroup('profiles')
          .where('profileUid', whereIn: profile!.following)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('error');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LinearProgressIndicator(
            color: pinkColor,
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
    final ModelProfile? profile = Provider.of<UserProvider>(context).getProfile;

    //display all users except current user
    if (profile!.profileUid != data['profileUid']) {
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
