import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../features/app_router.dart';
import '../../models/post.dart';
import '../../models/profile.dart';
import '../../providers/user_provider.dart';
import '../../utils/utils.dart';

class SavedPosts extends StatefulWidget {
  final dynamic snap;
  const SavedPosts({super.key, this.snap});

  @override
  State<SavedPosts> createState() => _SavedPostsState();
}

class _SavedPostsState extends State<SavedPosts> {
  @override
  Widget build(BuildContext context) {
    final ModelProfile? profile = Provider.of<UserProvider>(context).getProfile;
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Saved Posts'),
          ],
        ),
      ),
      body: profile!.savedPost.isEmpty
          ? const Center(
              child: Text('No posts available.'),
            )
          : FutureBuilder(
              future: FirebaseFirestore.instance.collection('posts').where('postId', whereIn: profile.savedPost).get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: theme.colorScheme.secondary,
                    ),
                  );
                }

                if (!snapshot.hasData) {
                  return const Center(
                    child: Text('No posts available.'),
                  );
                }

                return GridView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data!.docs.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 5, mainAxisSpacing: 1.5, childAspectRatio: 1),
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
                              fit: BoxFit.cover,
                            ),
                          );
                        } else {
                          mediaWidget = const Text('file format not available');
                        }

                        // Fetch username
                        String username = profileSnapshot.data!.docs.isNotEmpty ? profileSnapshot.data!.docs.first['username'] : '';

                        return GestureDetector(
                          onTap: () {
                            context.goNamed(
                              AppRouter.openPostFromFeed.name,
                              pathParameters: {
                                'postId': post.postId,
                                'profileUid': post.profileUid,
                                'username': username,
                              },
                            );
                          },
                          child: mediaWidget,
                        );
                      },
                    );
                  },
                );
              },
            ),
    );
  }
}
