import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import '../open_post_screen.dart';

class SavedPosts extends StatefulWidget {
  const SavedPosts({super.key});

  @override
  State<SavedPosts> createState() => _SavedPostsState();
}

class _SavedPostsState extends State<SavedPosts> {
  @override
  Widget build(BuildContext context) {
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
      body: FutureBuilder(
        future: FirebaseFirestore.instance.collection('users').doc('uid').get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: pinkColor,
              ),
            );
          }

          var savedPostIds = snapshot.data!.get('savedPost') ?? [];

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(
              child: Text('No posts available.'),
            );
          }

          return GridView.builder(
            shrinkWrap: true,
            itemCount: savedPostIds.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 5,
                mainAxisSpacing: 1.5,
                childAspectRatio: 1),
            itemBuilder: (context, index) {
              DocumentSnapshot snap = savedPostIds[index];
              return GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => OpenPost(
                        postId: snap['postId'],
                        uid: snap['uid'],
                        username: snap['username'],
                      ),
                    ),
                  );
                },
                child: Container(
                  child: Image(
                    image: NetworkImage(snap['postUrl']),
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
