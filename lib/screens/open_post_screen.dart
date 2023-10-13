import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../utils/colors.dart';
import '../utils/global_variables.dart';
import '../widgets/post_card_exp.dart';

class OpenPost extends StatefulWidget {
  const OpenPost({
    super.key,
    required this.postId,
    required this.profileUid,
    required this.username,
  });
  final String postId;
  final String username;
  final String profileUid;

  @override
  State<OpenPost> createState() => _OpenPostState();
}

class _OpenPostState extends State<OpenPost> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final itemController = ItemScrollController();

  void scrollToPost(List posts) {
    itemController.jumpTo(
      index: posts.indexWhere((element) => element['postId'] == widget.postId),
      alignment: 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: width > webScreenSize
          ? null
          : AppBar(
              backgroundColor: mobileBackgroundColor,
              centerTitle: false,
              title: Text('Post from ${widget.username}')),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .where('profileUid', isEqualTo: widget.profileUid)
            .orderBy('datePublished', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: pinkColor,
              ),
            );
          }
          // POST CARD
          WidgetsBinding.instance.addPostFrameCallback((_) {
            scrollToPost(snapshot.data!.docs);
          });
          return ScrollablePositionedList.builder(
            initialScrollIndex: snapshot.data!.docs
                .indexWhere((element) => element['postId'] == widget.postId),
            itemScrollController: itemController,
            key: _listKey,
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
