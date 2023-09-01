import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pets_social/models/user.dart';
import 'package:pets_social/providers/user_provider.dart';
import 'package:pets_social/resources/firestore_methods.dart';
import 'package:pets_social/screens/comments_screen.dart';
import 'package:pets_social/screens/profile_screen.dart';
import 'package:pets_social/utils/colors.dart';
import 'package:pets_social/utils/utils.dart';
import 'package:pets_social/widgets/like_animation.dart';
import 'package:pets_social/widgets/save_post_animation.dart';
import 'package:provider/provider.dart';

import 'bone_animation.dart';
import 'fish_animation.dart';

class PostCardExp extends StatefulWidget {
  final snap;
  const PostCardExp({super.key, required this.snap});

  @override
  State<PostCardExp> createState() => _PostCardExpState();
}

class _PostCardExpState extends State<PostCardExp> {
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
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        gradient: const LinearGradient(
          colors: [
            Color.fromARGB(255, 157, 110, 157),
            Color.fromARGB(255, 240, 177, 136),
          ],
        ),
      ),
      padding: const EdgeInsets.only(bottom: 10),
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // HEADER SECTION
          Stack(
            alignment: AlignmentDirectional.topEnd,
            children: [
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
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child: CachedNetworkImage(
                        imageUrl: widget.snap['postUrl'],
                      ),
                    ),
                    AnimatedOpacity(
                      duration: const Duration(milliseconds: 200),
                      opacity: isLikeAnimating ? 1 : 0,
                      child: LikeAnimation(
                        isAnimating: isLikeAnimating,
                        duration: const Duration(
                          milliseconds: 400,
                        ),
                        onEnd: () {
                          setState(() {
                            isLikeAnimating = false;
                          });
                        },
                        child: const Icon(Icons.favorite,
                            color: Colors.white, size: 120),
                      ),
                    )
                  ],
                ),
              ),
              //POST HEADER
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        String uid = widget.snap['uid'];
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfileScreen(uid: uid),
                          ),
                        );
                      },
                      child: CircleAvatar(
                        radius: 15,
                        backgroundImage: NetworkImage(widget.snap['profImage']),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                String uid = widget.snap['uid'];
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ProfileScreen(uid: uid),
                                  ),
                                );
                              },
                              child: Text(
                                widget.snap['username'],
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
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
                            child: SavePostAnimation(
                              isAnimating: user?.savedPost != null &&
                                  user!.savedPost
                                      .contains(widget.snap['postId']),
                              smallLike: true,
                              child: InkWell(
                                onTap: () async {
                                  await FirestoreMethods()
                                      .savePost(widget.snap['postId'],
                                          user!.uid, user.savedPost)
                                      .then((_) {
                                    setState(() {
                                      Provider.of<UserProvider>(context,
                                              listen: false)
                                          .refreshUser();
                                    });
                                  });
                                },
                                child: Icon(
                                  (user?.savedPost != null &&
                                          user!.savedPost
                                              .contains(widget.snap['postId']))
                                      ? Icons.bookmark
                                      : Icons.bookmark_border,
                                ),
                              ),
                            ),
                          ),
                          //3 DOTS
                          InkWell(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) => Dialog(
                                  child: ListView(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                    shrinkWrap: true,
                                    children: [
                                      widget.snap['uid'] == user!.uid
                                          ? InkWell(
                                              onTap: () async {
                                                FirestoreMethods().deletePost(
                                                    widget.snap['postId']);
                                                Navigator.of(context).pop();
                                              },
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 12,
                                                        horizontal: 16),
                                                child: const Text('Delete'),
                                              ),
                                            )
                                          : const Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 12, horizontal: 16),
                                              child: Text('Block user'),
                                            )
                                    ],
                                  ),
                                ),
                              );
                            },
                            child: Icon(Icons.more_vert),
                          ),
                        ],
                      ),
                    )),
                  ],
                ),
              ),
              //LIKE, FISH, BONE SECTION
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 70),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Color.fromARGB(100, 0, 0, 0),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          //ARROW LEFT SWIPE
                          InkWell(
                            onTap: () {},
                            child: const Icon(
                              Icons.arrow_left,
                            ),
                          ),
                          // FISH
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: FishAnimation(
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
                                          widget.snap['fish']
                                              .contains(user!.uid))
                                      ? 'assets/fish.png'
                                      : 'assets/fish_border.png',
                                  width: 30,
                                  height: 30,
                                ),
                              ),
                            ),
                          ),
                          //LIKES
                          LikeAnimation(
                            isAnimating: widget.snap['likes'] != null &&
                                widget.snap['likes'].contains(user!.uid),
                            smallLike: true,
                            child: InkWell(
                              onTap: () async {
                                await FirestoreMethods().likePost(
                                    widget.snap['postId'],
                                    user!.uid,
                                    widget.snap['likes']);
                              },
                              child: Image.asset(
                                (widget.snap['likes'] != null &&
                                        widget.snap['likes']
                                            .contains(user!.uid))
                                    ? 'assets/like.png'
                                    : 'assets/like_border.png',
                                width: 40,
                                height: 40,
                              ),
                            ),
                          ),
                          //SizedBox(width: 10), // Add space
                          //BONES
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15),
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
                                          widget.snap['bones']
                                              .contains(user!.uid))
                                      ? 'assets/bone.png'
                                      : 'assets/bone_border.png',
                                  width: 30,
                                  height: 30,
                                ),
                              ),
                            ),
                          ),
                          //ARROW RIGHT SWIPE
                          InkWell(
                            onTap: () {},
                            child: const Icon(
                              Icons.arrow_right,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          //DESCRIPTION AND COMMENTS
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  // width: double.infinity,
                  padding: const EdgeInsets.only(
                    top: 8,
                  ),
                  child: RichText(
                    text: TextSpan(
                        style: const TextStyle(color: primaryColor),
                        children: [
                          TextSpan(
                            text: widget.snap['username'],
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          TextSpan(
                              text: ' ${widget.snap['description']}',
                              style: TextStyle(fontSize: 15))
                        ]),
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.only(top: 8),
                //   child: Row(
                //       mainAxisAlignment: MainAxisAlignment.end,
                //       children: [
                //         //show number of likes
                //         DefaultTextStyle(
                //           style: Theme.of(context)
                //               .textTheme
                //               .subtitle2!
                //               .copyWith(fontWeight: FontWeight.w800),
                //           child: Text(
                //             '${widget.snap['likes'].length} likes',
                //             style: Theme.of(context).textTheme.bodyText2,
                //           ),
                //         ),
                //         SizedBox(width: 10), // Add space
                //         //show number of fish
                //         DefaultTextStyle(
                //           style: Theme.of(context)
                //               .textTheme
                //               .subtitle2!
                //               .copyWith(fontWeight: FontWeight.w800),
                //           child: Text(
                //             '${widget.snap['fish'] != null ? widget.snap['fish'].length : 0} fish',
                //             style: Theme.of(context).textTheme.bodyText2,
                //           ),
                //         ),
                //         SizedBox(width: 10), // Add space
                //         //show number of bones
                //         DefaultTextStyle(
                //           style: Theme.of(context)
                //               .textTheme
                //               .subtitle2!
                //               .copyWith(fontWeight: FontWeight.w800),
                //           child: Text(
                //             '${widget.snap['bones'] != null ? widget.snap['bones'].length : 0} bones',
                //             style: Theme.of(context).textTheme.bodyText2,
                //           ),
                //         ),
                //       ]),
                // ),

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
                      style: const TextStyle(fontSize: 15, color: Colors.white),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    DateFormat.yMMMd()
                        .format(widget.snap['datePublished'].toDate()),
                    style: const TextStyle(fontSize: 12, color: Colors.white),
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
