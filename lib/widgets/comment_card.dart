import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../providers/user_provider.dart';
import '../resources/firestore_methods.dart';
import 'like_animation.dart';

class CommentCard extends StatefulWidget {
  final snap;
  const CommentCard({super.key, required this.snap});

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  @override
  Widget build(BuildContext context) {
    final User? user = Provider.of<UserProvider>(context).getUser;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
      child: Row(children: [
        CircleAvatar(
          backgroundImage: NetworkImage(widget.snap['profilePic']),
          radius: 18,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                          text: widget.snap['name'],
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(
                        text: ' ${widget.snap['text']}',
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    DateFormat.yMMMd()
                        .format(widget.snap['datePublished'].toDate()),
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w400),
                  ),
                )
              ],
            ),
          ),
        ),
        // Container(
        //   padding: const EdgeInsets.all(8),
        //   //const Icon(Icons.favorite, size: 16),
        //   child: Image.asset('assets/like_border.png'),
        //   width: 24,
        //   height: 24,
        // ),

        LikeAnimation(
          isAnimating: widget.snap['likes'] != null &&
              widget.snap['likes'].contains(user!.uid),
          smallLike: true,
          child: InkWell(
            onTap: () async {
              await FirestoreMethods().likeComment(widget.snap['postId'],
                  widget.snap['commentId'], user!.uid, widget.snap['likes']);
            },
            child: Image.asset(
              (widget.snap['likes'] != null &&
                      widget.snap['likes'].contains(user!.uid))
                  ? 'assets/like.png'
                  : 'assets/like_border.png',
              width: 14,
              height: 14,
            ),
          ),
        ),
      ]),
    );
  }
}
