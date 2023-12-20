import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pets_social/providers/post/post_provider.dart';
import 'package:pets_social/providers/user/user_provider.dart';
import 'package:pets_social/services/firestore_methods.dart';

import '../models/profile.dart';
import '../widgets/comment_card.dart';

class CommentsScreen extends ConsumerStatefulWidget {
  final dynamic snap;
  const CommentsScreen({super.key, required this.snap});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends ConsumerState<CommentsScreen> {
  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ModelProfile? profile = ref.watch(userProvider);
    final ThemeData theme = Theme.of(context);
    final getComments = ref.watch(getCommentsProvider(widget.snap['postId']));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        title: const Text('Comments'),
        centerTitle: false,
      ),
      body: getComments.when(
        error: (error, stacktrace) => Text('error: $error'),
        loading: () => Center(
          child: CircularProgressIndicator(
            color: theme.colorScheme.secondary,
          ),
        ),
        data: (getComments) {
          return ListView.builder(
            itemCount: getComments.docs.length,
            itemBuilder: (context, index) => CommentCard(
              snap: getComments.docs[index].data(),
            ),
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          height: kToolbarHeight,
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          padding: const EdgeInsets.only(left: 16, right: 8),
          child: Row(
            children: [
              CircleAvatar(
                backgroundImage: (profile != null && profile.photoUrl != null) ? NetworkImage(profile.photoUrl!) : const AssetImage('assets/default_pic') as ImageProvider<Object>,
                radius: 18,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 8.0),
                  child: TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      hintText: 'Comment as ${profile!.username}',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () async {
                  await FirestoreMethods().postComment(widget.snap['postId'], _commentController.text, profile.profileUid, profile.username, profile.photoUrl ?? "", widget.snap['likes']);
                  setState(() {
                    _commentController.text = "";
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 8,
                  ),
                  child: Text(
                    'Post',
                    style: TextStyle(
                      color: theme.colorScheme.secondary,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
