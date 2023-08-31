import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';
import '../providers/user_provider.dart';
import '../utils/colors.dart';
import '../utils/global_variables.dart';
import '../widgets/post_card_exp.dart';

class OpenPost extends StatelessWidget {
  const OpenPost(
      {super.key,
      required this.postId,
      required this.username,
      required this.fish});
  final String postId;
  final String username;
  final List fish;

  @override
  Widget build(BuildContext context) {
    final User? user = Provider.of<UserProvider>(context).getUser;

    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: width > webScreenSize
          ? null
          : AppBar(
              backgroundColor: mobileBackgroundColor,
              centerTitle: false,
              title: Text('Post from $username')),
      body: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('posts')
            .where('postId', isEqualTo: postId)
            .where('username', isEqualTo: username)
            .where('fish', isEqualTo: fish)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          // POST CARD
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) => Container(
              margin: EdgeInsets.symmetric(
                horizontal: width > webScreenSize ? width * 0.3 : 0,
                vertical: width > webScreenSize ? 15 : 0,
              ),
              child: PostCardExp(
                snap: snapshot.data!.docs[index].data(),
              ),
            ),
          );
        },
      ),
    );
  }
}
