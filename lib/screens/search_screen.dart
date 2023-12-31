import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:pets_social/features/app_router.dart';
import 'package:pets_social/models/profile.dart';
import 'package:pets_social/responsive/responsive_layout_screen.dart';
import '../models/post.dart';
import '../utils/utils.dart';

class SearchScreen extends StatefulWidget {
  final dynamic snap;
  const SearchScreen({super.key, this.snap});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  bool isShowUsers = false;
  List<ModelProfile> profiles = [];
  List<ModelProfile> profilesFiltered = [];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback(
      (_) async {
        QuerySnapshot<Map<String, dynamic>> usersSnapshot = await FirebaseFirestore.instance.collectionGroup('profiles').get();

        for (QueryDocumentSnapshot doc in usersSnapshot.docs) {
          ModelProfile profile = ModelProfile.fromSnap(doc);

          profiles.add(profile);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      //SEARCHBAR
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        title: TextFormField(
          controller: searchController,
          decoration: InputDecoration(
              labelText: 'Search for user',
              labelStyle: TextStyle(color: theme.colorScheme.secondary),
              suffixIcon: isShowUsers
                  ? GestureDetector(
                      child: const Icon(Icons.search_off),
                      onTap: () {
                        setState(
                          () {
                            searchController.clear();
                            isShowUsers = false;
                          },
                        );
                      },
                    )
                  : const Icon(Icons.search)),
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
          //SEARCHING FOR PROFILES
          ? ListView.builder(
              itemCount: profilesFiltered.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    context.goNamed(
                      AppRouter.profileFromSearch.name,
                      pathParameters: {
                        'profileUid': profilesFiltered[index].profileUid,
                      },
                    );
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
          //POST GRID
          : Container(
              padding: ResponsiveLayout.isWeb(context) ? const EdgeInsets.symmetric(horizontal: 200) : const EdgeInsets.symmetric(horizontal: 0),
              child: FutureBuilder(
                future: FirebaseFirestore.instance.collection('posts').orderBy('datePublished', descending: true).get(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                        child: CircularProgressIndicator(
                      color: theme.colorScheme.secondary,
                    ));
                  }

                  return MasonryGridView.builder(
                    itemCount: (snapshot.data! as dynamic).docs.length,
                    itemBuilder: (context, index) {
                      ModelPost post = ModelPost.fromSnap(snapshot.data!.docs[index]);

                      return FutureBuilder(
                          future: FirebaseFirestore.instance.collectionGroup('profiles').where('profileUid', isEqualTo: post.profileUid).get(),
                          builder: (context, profileSnapshot) {
                            if (profileSnapshot.connectionState == ConnectionState.waiting) {
                              return Container();
                            }
                            Widget mediaWidget;
                            final String contentType = getContentTypeFromUrl(post.fileType);
                            //return video
                            if (contentType == 'video') {
                              mediaWidget = ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: Image(
                                  image: NetworkImage(post.videoThumbnail),
                                  fit: BoxFit.cover,
                                ),
                              );
                              //return image
                            } else if (contentType == 'image') {
                              mediaWidget = ClipRRect(
                                borderRadius: BorderRadius.circular(10.0),
                                child: Image(
                                  image: NetworkImage(post.postUrl),
                                  fit: BoxFit.fitWidth,
                                ),
                              );
                            } else {
                              mediaWidget = const Text('file format not available');
                            }

                            if (!snapshot.hasData) {
                              return Center(
                                  child: CircularProgressIndicator(
                                color: theme.colorScheme.secondary,
                              ));
                            }

                            // Fetch username
                            String username = profileSnapshot.data!.docs.isNotEmpty ? profileSnapshot.data!.docs.first['username'] : '';

                            return GestureDetector(
                              onTap: () {
                                String profileUid = (snapshot.data! as dynamic).docs[index]['profileUid'];
                                String postId = (snapshot.data! as dynamic).docs[index]['postId'];

                                context.pushNamed(
                                  AppRouter.openPostFromSearch.name,
                                  pathParameters: {
                                    'postId': postId,
                                    'profileUid': profileUid,
                                    'username': username,
                                  },
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20.0),
                                    color: Colors.black,
                                  ),
                                  width: double.infinity,
                                  constraints: const BoxConstraints(maxHeight: 300),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: mediaWidget,
                                  ),
                                ),
                              ),
                            );
                          });
                    },
                    gridDelegate: ResponsiveLayout.isWeb(context) ? const SliverSimpleGridDelegateWithFixedCrossAxisCount(crossAxisCount: 6) : const SliverSimpleGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                  );
                },
              ),
            ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
