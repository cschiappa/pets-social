import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pets_social/models/profile.dart';
import 'package:pets_social/screens/open_post_screen.dart';
import 'package:pets_social/screens/profile_screen.dart';
import 'package:pets_social/utils/colors.dart';

import '../models/post.dart';
import '../utils/global_variables.dart';
import '../utils/utils.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  bool isShowUsers = false;
  var userData = {};
  List<ModelProfile> profiles = [];
  List<ModelProfile> profilesFiltered = [];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      QuerySnapshot<Map<String, dynamic>> usersSnapshot =
          await FirebaseFirestore.instance.collectionGroup('profiles').get();

      for (QueryDocumentSnapshot doc in usersSnapshot.docs) {
        ModelProfile profile = ModelProfile.fromSnap(doc);

        profiles.add(profile);
      }
    });
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
            onChanged: (value) {
              setState(() {
                isShowUsers = true;

                profilesFiltered = profiles
                    .where((element) => element.username
                        .toLowerCase()
                        .contains(value.toLowerCase()))
                    .toList();
              });
            }),
      ),
      //searching for someone
      body: isShowUsers
          ? ListView.builder(
              itemCount: profilesFiltered.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfileScreen(
                            profileUid: profilesFiltered[index].profileUid,
                          ),
                        ));
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
          : Container(
              padding: MediaQuery.of(context).size.width > webScreenSize
                  ? const EdgeInsets.symmetric(horizontal: 200)
                  : const EdgeInsets.symmetric(horizontal: 0),
              child: FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection('posts')
                    .orderBy('datePublished', descending: true)
                    .get(),
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
                    itemBuilder: (context, index) {
                      ModelPost post =
                          ModelPost.fromSnap(snapshot.data!.docs[index]);

                      Widget mediaWidget;
                      final String contentType =
                          getContentTypeFromUrl(post.fileType);

                      if (contentType == 'video') {
                        mediaWidget = ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Image(
                            image: NetworkImage(post.videoThumbnail),
                            fit: BoxFit.cover,
                          ),
                        );
                      } else if (contentType == 'image') {
                        // If it's not a video, return an image.
                        mediaWidget = ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: Image(
                            image: NetworkImage(post.postUrl),
                            fit: BoxFit.cover,
                          ),
                        );
                      } else {
                        mediaWidget = const Text('file format not available');
                      }

                      if (!snapshot.hasData) {
                        return const Center(
                            child: CircularProgressIndicator(
                          color: pinkColor,
                        ));
                      }

                      return GestureDetector(
                        onTap: () {
                          String profileUid = (snapshot.data! as dynamic)
                              .docs[index]['profileUid'];
                          String username = (snapshot.data! as dynamic)
                              .docs[index]['username'];
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
                            child: mediaWidget,
                          ),
                        ),
                      );
                    },
                    gridDelegate: MediaQuery.of(context).size.width >
                            webScreenSize
                        ? const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 6)
                        : const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2),
                  );
                },
              ),
            ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }
}
