import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/post.dart';
import '../../models/profile.dart';
import '../../providers/user_provider.dart';
import '../../utils/colors.dart';
import '../../utils/utils.dart';
import '../open_post_screen.dart';

class SavedPosts extends StatefulWidget {
  final snap;
  const SavedPosts({super.key, this.snap});

  @override
  State<SavedPosts> createState() => _SavedPostsState();
}

class _SavedPostsState extends State<SavedPosts> {
  @override
  Widget build(BuildContext context) {
    final ModelProfile? profile = Provider.of<UserProvider>(context).getProfile;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
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
              future: FirebaseFirestore.instance
                  .collection('posts')
                  .where('postId', whereIn: profile.savedPost)
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: pinkColor,
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
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 1.5,
                      childAspectRatio: 1),
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

                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => OpenPost(
                              postId: post.postId,
                              profileUid: post.profileUid,
                              username: post.username,
                            ),
                          ),
                        );
                      },
                      child: mediaWidget,
                    );
                  },
                );
              },
            ),
    );
  }
}
