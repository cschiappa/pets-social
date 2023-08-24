import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pets_social/screens/profile_screen.dart';

import '../utils/global_variables.dart';

class SavedPosts extends StatefulWidget {
  const SavedPosts({super.key});

  @override
  State<SavedPosts> createState() => _SavedPostsState();
}

class _SavedPostsState extends State<SavedPosts> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: FirebaseFirestore.instance.collection('posts').get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          //search post grid
          return StaggeredGridView.countBuilder(
            crossAxisCount: 3,
            itemCount: (snapshot.data! as dynamic).docs.length,
            itemBuilder: (context, index) => GestureDetector(
              onTap: () {
                String uid = (snapshot.data! as dynamic).docs[index]['uid'];
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfileScreen(
                        uid: uid,
                      ),
                    ));
              },
              child: Image.network(
                  (snapshot.data! as dynamic).docs[index]['postUrl']),
            ),
            staggeredTileBuilder: (index) =>
                MediaQuery.of(context).size.width > webScreenSize
                    ? StaggeredTile.count(
                        (index % 7 == 0) ? 1 : 1, (index % 7 == 0) ? 1 : 1)
                    : StaggeredTile.count(
                        (index % 7 == 0) ? 2 : 1, (index % 7 == 0) ? 2 : 1),
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
          );
        },
      ),
    );
  }
}
