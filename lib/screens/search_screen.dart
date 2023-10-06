import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:http/http.dart';
import 'package:pets_social/screens/open_post_screen.dart';
import 'package:pets_social/screens/profile_screen.dart';
import 'package:pets_social/utils/colors.dart';

import '../utils/global_variables.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  bool isShowUsers = false;
  var userData = {};

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //searchbar
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: TextFormField(
            controller: searchController,
            decoration: const InputDecoration(
              labelText: 'Search for user',
              labelStyle: TextStyle(color: pinkColor),
            ),
            onFieldSubmitted: (String _) {
              setState(() {
                isShowUsers = true;
              });
            }),
      ),
      //searching for someone
      body: isShowUsers
          ? FutureBuilder(
              future: FirebaseFirestore.instance
                  .collectionGroup('profiles')
                  .where('username',
                      isGreaterThanOrEqualTo: searchController.text)
                  .get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: pinkColor,
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: (snapshot.data! as dynamic).docs.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        String profileUid = (snapshot.data! as dynamic)
                            .docs[index]['profileUid'];

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProfileScreen(
                                profileUid: profileUid,
                              ),
                            ));
                      },
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(
                              (snapshot.data! as dynamic).docs[index]
                                  ['photoUrl']),
                        ),
                        title: Text((snapshot.data! as dynamic).docs[index]
                            ['username']),
                      ),
                    );
                  },
                );
              },
            )
          : Container(
              padding: MediaQuery.of(context).size.width > webScreenSize
                  ? const EdgeInsets.symmetric(horizontal: 200)
                  : const EdgeInsets.symmetric(horizontal: 0),
              child: FutureBuilder(
                future: FirebaseFirestore.instance.collection('posts').get(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                        child: CircularProgressIndicator(
                      color: pinkColor,
                    ));
                  }
                  //search post grid
                  return MasonryGridView.builder(
                    itemCount: (snapshot.data! as dynamic).docs.length,
                    itemBuilder: (context, index) => GestureDetector(
                      onTap: () {
                        String profileUid = (snapshot.data! as dynamic)
                            .docs[index]['profileUid'];
                        String username =
                            (snapshot.data! as dynamic).docs[index]['username'];
                        String postId =
                            (snapshot.data! as dynamic).docs[index]['postId'];
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OpenPost(
                                  postId: postId,
                                  profileUid: profileUid,
                                  username: username),
                            ));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network((snapshot.data! as dynamic)
                              .docs[index]['postUrl']),
                        ),
                      ),
                    ),
                    gridDelegate: MediaQuery.of(context).size.width >
                            webScreenSize
                        ? const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4)
                        : const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2),
                  );
                },
              ),
            ),
    );
  }
}
