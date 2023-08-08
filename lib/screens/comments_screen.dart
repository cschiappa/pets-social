import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pets_social/utils/colors.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../providers/user_provider.dart';
import '../widgets/comment_card.dart';

class CommentsScreen extends StatefulWidget {
  const CommentsScreen({super.key});

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  @override
  Widget build(BuildContext context) {
    final User? user = Provider.of<UserProvider>(context).getUser;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: const Text('Comments'),
        centerTitle: false,
      ),
      body: CommentCard(),
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
                backgroundImage: NetworkImage(user!.photoUrl),
                radius: 18,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 8.0),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Comment as ${user.username}',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 8,
                  ),
                  child: const Text(
                    'Post',
                    style: TextStyle(
                      color: Color.fromRGBO(242, 102, 139, 1),
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
