import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/profile.dart';
import '../providers/user_provider.dart';
import '../resources/firestore_methods.dart';
import '../screens/profile_screen.dart';
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
    final ModelProfile? profile = Provider.of<UserProvider>(context).getProfile;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
      child: Row(children: [
        GestureDetector(
          onTap: () {
            String profileUid = widget.snap['profileUid'];
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileScreen(profileUid: profileUid),
                ));
          },
          child: CircleAvatar(
            backgroundImage: NetworkImage(widget.snap['profilePic']),
            radius: 18,
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //USERNAME AND COMMENT
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        String profileUid = widget.snap['profileUid'];
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ProfileScreen(profileUid: profileUid),
                            ));
                      },
                      child: RichText(
                        text: TextSpan(
                            text: widget.snap['name'],
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        text: ' ${widget.snap['text']}',
                      ),
                    ),
                  ],
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
        LikeAnimation(
          isAnimating: widget.snap['likes'] != null &&
              widget.snap['likes'].contains(profile!.profileUid),
          smallLike: true,
          child: InkWell(
            onTap: () async {
              await FirestoreMethods().likeComment(
                  widget.snap['postId'],
                  widget.snap['commentId'],
                  profile!.profileUid,
                  widget.snap['likes']);
            },
            child: Image.asset(
              (widget.snap['likes'] != null &&
                      widget.snap['likes'].contains(profile!.profileUid))
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
