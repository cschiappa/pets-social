import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pets_social/providers/user_provider.dart';
import 'package:pets_social/responsive/responsive_layout_screen.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import '../widgets/post_card.dart';

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
  bool firstScroll = true;

  //SCROLL
  void scrollToPost(List posts) {
    if (firstScroll) {
      itemController.jumpTo(
        index: posts.indexWhere((element) => element['postId'] == widget.postId),
        alignment: 0,
      );
      firstScroll = false;
    }
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Provider.of<UserProvider>(context, listen: false).refreshProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: ResponsiveLayout.isWeb(context) ? null : AppBar(backgroundColor: theme.appBarTheme.backgroundColor, centerTitle: false, title: Text('Post from ${widget.username}')),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('posts').where('profileUid', isEqualTo: widget.profileUid).orderBy('datePublished', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting || Provider.of<UserProvider>(context).getProfile == null) {
            return Center(
              child: CircularProgressIndicator(
                color: theme.colorScheme.secondary,
              ),
            );
          }

          // POST CARD
          WidgetsBinding.instance.addPostFrameCallback((_) {
            scrollToPost(snapshot.data!.docs);
          });
          return ScrollablePositionedList.builder(
            initialScrollIndex: snapshot.data!.docs.indexWhere((element) => element['postId'] == widget.postId),
            itemScrollController: itemController,
            key: _listKey,
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) => Container(
              margin: EdgeInsets.symmetric(
                horizontal: ResponsiveLayout.isWeb(context) ? width * 0.3 : 0,
                vertical: ResponsiveLayout.isWeb(context) ? 15 : 0,
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
