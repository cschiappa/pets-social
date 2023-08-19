import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pets_social/models/user.dart';
import 'package:pets_social/providers/user_provider.dart';
import 'package:pets_social/resources/firestore_methods.dart';
import 'package:pets_social/screens/comments_screen.dart';
import 'package:pets_social/utils/colors.dart';
import 'package:pets_social/utils/utils.dart';
import 'package:pets_social/widgets/like_animation.dart';
import 'package:provider/provider.dart';

import 'bone_animation.dart';
import 'fish_animation.dart';

class PostCard extends StatefulWidget {
  final snap;
  const PostCard({super.key, required this.snap});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLikeAnimating = false;
  int commentLen = 0;

  @override
  void initState() {
    super.initState();
    getComments();
  }

  void getComments() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.snap['postId'])
          .collection('comments')
          .get();

      commentLen = snap.docs.length;
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final User? user = Provider.of<UserProvider>(context).getUser;
    return Container(
      //boundary needed for web

      color: mobileBackgroundColor,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          // HEADER SECTION
          Container(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16)
                .copyWith(right: 0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 15,
                  backgroundImage: NetworkImage(widget.snap['profImage']),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.snap['username'],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                IconButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) => Dialog(
                                child: ListView(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                  shrinkWrap: true,
                                  children: [
                                    'Delete',
                                  ]
                                      .map(
                                        (e) => InkWell(
                                          onTap: () async {
                                            FirestoreMethods().deletePost(
                                                widget.snap['postId']);
                                            Navigator.of(context).pop();
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 12, horizontal: 16),
                                            child: Text(e),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                ),
                              ));
                    },
                    icon: Icon(Icons.more_vert)),
              ],
            ),
          ),

          //IMAGE SECTION
          GestureDetector(
            //double tap for like
            onDoubleTap: () async {
              await FirestoreMethods().likePost(
                  widget.snap['postId'], user!.uid, widget.snap['likes']);
              setState(() {
                isLikeAnimating = true;
              });
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.35,
                  width: double.infinity,
                  child: Image.network(
                    widget.snap['postUrl'],
                    fit: BoxFit.cover,
                  ),
                ),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: isLikeAnimating ? 1 : 0,
                  child: LikeAnimation(
                    child: const Icon(Icons.favorite,
                        color: Colors.white, size: 120),
                    isAnimating: isLikeAnimating,
                    duration: const Duration(
                      milliseconds: 400,
                    ),
                    onEnd: () {
                      setState(() {
                        isLikeAnimating = false;
                      });
                    },
                  ),
                )
              ],
            ),
          ),

          //LIKE COMMENT SECTION
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                // LIKES
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: LikeAnimation(
                    isAnimating: widget.snap['likes'] != null &&
                        widget.snap['likes'].contains(user!.uid),
                    smallLike: true,
                    child: InkWell(
                      onTap: () async {
                        await FirestoreMethods().likePost(widget.snap['postId'],
                            user!.uid, widget.snap['likes']);
                      },
                      child: Image.asset(
                        (widget.snap['likes'] != null &&
                                widget.snap['likes'].contains(user!.uid))
                            ? 'assets/like.png'
                            : 'assets/like_border.png',
                        width: 24,
                        height: 24,
                      ),
                    ),
                  ),
                ),
                //FISH
                FishAnimation(
                  isAnimating: widget.snap['fish'] != null &&
                      widget.snap['fish'].contains(user!.uid),
                  smallLike: true,
                  child: InkWell(
                    onTap: () async {
                      await FirestoreMethods().giveFishToPost(
                          widget.snap['postId'],
                          user!.uid,
                          widget.snap['fish']);
                    },
                    child: Image.asset(
                      (widget.snap['fish'] != null &&
                              widget.snap['fish'].contains(user!.uid))
                          ? 'assets/fish.png'
                          : 'assets/fish_border.png',
                      width: 24,
                      height: 24,
                    ),
                  ),
                ),
                //SizedBox(width: 10), // Add space
                //BONES
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: BoneAnimation(
                    isAnimating: widget.snap['bones'] != null &&
                        widget.snap['bones'].contains(user!.uid),
                    smallLike: true,
                    child: InkWell(
                      onTap: () async {
                        await FirestoreMethods().giveBoneToPost(
                            widget.snap['postId'],
                            user!.uid,
                            widget.snap['bones']);
                      },
                      child: Image.asset(
                        (widget.snap['bones'] != null &&
                                widget.snap['bones'].contains(user!.uid))
                            ? 'assets/bone.png'
                            : 'assets/bone_border.png',
                        width: 24,
                        height: 24,
                      ),
                    ),
                  ),
                ),

                Expanded(
                    child: Align(
                  alignment: Alignment.bottomRight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      //COMMENT
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: InkWell(
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => CommentsScreen(
                                snap: widget.snap,
                              ),
                            ),
                          ),
                          child: Image.asset(
                            'assets/comment.png',
                            width: 24,
                            height: 24,
                          ),
                        ),
                      ),
                      //SHARE
                      InkWell(
                        onTap: () {},
                        child: const Icon(
                          Icons.share,
                        ),
                      ),
                      //BOOKMARK
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: InkWell(
                          onTap: () {},
                          child: const Icon(Icons.bookmark_border),
                        ),
                      ),
                    ],
                  ),
                ))
              ],
            ),
          ),

          //DESCRIPTION AND COMMENTS
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  //show number of likes
                  DefaultTextStyle(
                    style: Theme.of(context)
                        .textTheme
                        .subtitle2!
                        .copyWith(fontWeight: FontWeight.w800),
                    child: Text(
                      '${widget.snap['likes'].length} likes',
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  ),
                  SizedBox(width: 10), // Add space
                  //show number of fish
                  DefaultTextStyle(
                    style: Theme.of(context)
                        .textTheme
                        .subtitle2!
                        .copyWith(fontWeight: FontWeight.w800),
                    child: Text(
                      '${widget.snap['fish'] != null ? widget.snap['fish'].length : 0} fish',
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  ),
                  SizedBox(width: 10), // Add space
                  //show number of bones
                  DefaultTextStyle(
                    style: Theme.of(context)
                        .textTheme
                        .subtitle2!
                        .copyWith(fontWeight: FontWeight.w800),
                    child: Text(
                      '${widget.snap['bones'] != null ? widget.snap['bones'].length : 0} bones',
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  ),
                ]),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(
                    top: 8,
                  ),
                  child: RichText(
                    text: TextSpan(
                        style: const TextStyle(color: primaryColor),
                        children: [
                          TextSpan(
                            text: widget.snap['username'],
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: ' ${widget.snap['description']}',
                          )
                        ]),
                  ),
                ),

                // SHOW NUMBER OF COMMENTS
                InkWell(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => CommentsScreen(
                        snap: widget.snap,
                      ),
                    ),
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      'View all $commentLen comments',
                      style:
                          const TextStyle(fontSize: 16, color: secondaryColor),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    DateFormat.yMMMd()
                        .format(widget.snap['datePublished'].toDate()),
                    style: const TextStyle(fontSize: 16, color: secondaryColor),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
