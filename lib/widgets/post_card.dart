import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_video_player/cached_video_player.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:pets_social/models/profile.dart';
import 'package:pets_social/providers/user_provider.dart';
import 'package:pets_social/resources/firestore_methods.dart';
import 'package:pets_social/responsive/responsive_layout_screen.dart';
import 'package:pets_social/utils/utils.dart';
import 'package:pets_social/widgets/carousel_slider.dart';
import 'package:pets_social/widgets/like_animation.dart';
import 'package:pets_social/widgets/save_post_animation.dart';
import 'package:pets_social/widgets/text_field_input.dart';
import 'package:pets_social/widgets/video_player.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../features/app_router.dart';

class PostCardExp extends StatefulWidget {
  final dynamic snap;
  const PostCardExp({super.key, required this.snap});

  @override
  State<PostCardExp> createState() => _PostCardExpState();
}

class _PostCardExpState extends State<PostCardExp> {
  late CachedVideoPlayerController _videoController;
  bool isLikeAnimating = false;
  int commentLen = 0;
  final CarouselController _controller = CarouselController();
  final TextEditingController _descriptionController = TextEditingController();
  bool _isLoading = false;
  dynamic profileData;
  dynamic profileDocs;

  @override
  void initState() {
    super.initState();
    final videoUri = Uri.parse(widget.snap['postUrl']);
    _videoController = CachedVideoPlayerController.network(videoUri.toString())
      ..initialize().then((_) {
        setState(() {});
      });
    getComments();
    getData();
  }

  @override
  void dispose() {
    _videoController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  //GET DATA
  getData() async {
    try {
      profileData = await FirebaseFirestore.instance.collectionGroup('profiles').where('profileUid', isEqualTo: widget.snap['profileUid']).get();

      setState(() {
        profileDocs = profileData.docs.first.data();
      });
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
  }

  //EDIT POST
  Future<String> updatePost(StateSetter setState) async {
    setState(() {
      _isLoading = true;
    });
    String res = await FirestoreMethods().updatePost(
      postId: widget.snap['postId'],
      newDescription: _descriptionController.text,
    );

    setState(() {
      _isLoading = false;
    });

    return res;
  }

  //GET COMMENTS
  void getComments() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance.collection('posts').doc(widget.snap['postId']).collection('comments').get();

      commentLen = snap.docs.length;
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final videoUri = Uri.parse(widget.snap['postUrl']);
    final ModelProfile? profile = Provider.of<UserProvider>(context).getProfile;
    final ThemeData theme = Theme.of(context);
    final String contentType = getContentTypeFromUrl(widget.snap['fileType']);

    return SizedBox(
      child: Container(
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
            Stack(
              alignment: AlignmentDirectional.topEnd,
              children: [
                //DOUBLE TAP FOR LIKE
                GestureDetector(
                  onDoubleTap: () async {
                    await FirestoreMethods().likePost(widget.snap['postId'], profile!.profileUid, widget.snap['likes']);
                    setState(() {
                      isLikeAnimating = true;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: Colors.black,
                    ),
                    width: double.infinity,
                    constraints: const BoxConstraints(maxHeight: 600),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20.0),
                          child: () {
                            if (contentType == 'image') {
                              return SizedBox(
                                width: double.infinity,
                                child: CachedNetworkImage(
                                  imageUrl: widget.snap['postUrl'],
                                  fit: BoxFit.fitWidth,
                                ),
                              );
                            } else if (contentType == 'video') {
                              return VideoPlayerWidget(videoUrl: videoUri);
                            } else if (contentType == 'unknown') {
                              return const SizedBox.shrink(
                                child: Center(child: Text('unknown format')),
                              );
                            } else {
                              return const SizedBox.shrink();
                            }
                          }(),
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
                            child: Icon(Icons.favorite, color: theme.colorScheme.primary, size: 120),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                //POST HEADER
                Container(
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(100, 0, 0, 0),
                    borderRadius: BorderRadius.only(topRight: Radius.circular(20), topLeft: Radius.circular(20)),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                  child: Row(
                    children: [
                      //AVATAR
                      GestureDetector(
                        onTap: () {
                          String profileUid = widget.snap['profileUid'];
                          profileUid == profile!.profileUid
                              ? context.goNamed(
                                  AppRouter.profileScreen.name,
                                )
                              : context.pushNamed(
                                  AppRouter.navigateToProfile.name,
                                  pathParameters: {
                                    'profileUid': profileUid,
                                  },
                                );
                        },
                        child: CircleAvatar(
                            radius: 15,
                            backgroundImage: profileDocs != null
                                ? NetworkImage(
                                    profileDocs['photoUrl'],
                                  )
                                : null),
                      ),
                      //USERNAME
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  String profileUid = widget.snap['profileUid'];

                                  profileUid == profile!.profileUid
                                      ? context.goNamed(
                                          AppRouter.profileScreen.name,
                                        )
                                      : context.pushNamed(
                                          AppRouter.navigateToProfile.name,
                                          pathParameters: {
                                            'profileUid': profileUid,
                                          },
                                        );
                                },
                                child: Text(
                                  //widget.snap['username'],
                                  profileDocs == null ? "" : profileDocs['username'],
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      //ICONS
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
                                onTap: () => context.pushNamed(
                                  AppRouter.commentsFromFeed.name,
                                  extra: widget.snap,
                                  pathParameters: {
                                    'postId': widget.snap['postId'],
                                    'profileUid': widget.snap['profileUid'],
                                    'username': profileDocs['username'],
                                  },
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
                              onTap: () async {
                                String path = 'cschiappa.github.io/post/${widget.snap['postId']}/${widget.snap['profileUid']}/${profileDocs['username']}';
                                await Share.share(path, subject: 'Pets Social Link'
                                    //sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
                                    );
                              },
                              child: Icon(
                                Icons.share,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                            //BOOKMARK
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: SavePostAnimation(
                                isAnimating: profile?.savedPost != null && profile!.savedPost.contains(widget.snap['postId']),
                                smallLike: true,
                                child: InkWell(
                                  onTap: () async {
                                    await FirestoreMethods().savePost(widget.snap['postId'], profile!.profileUid, profile.savedPost).then((_) {
                                      setState(() {
                                        Provider.of<UserProvider>(context, listen: false).refreshProfile();
                                      });
                                    });
                                  },
                                  child: Icon(
                                    (profile?.savedPost != null && profile!.savedPost.contains(widget.snap['postId'])) ? Icons.bookmark : Icons.bookmark_border,
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                              ),
                            ),
                            //3 DOTS
                            InkWell(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => Padding(
                                    padding: ResponsiveLayout.isWeb(context) ? EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / 3) : const EdgeInsets.all(0),
                                    child: Dialog(
                                      child: StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
                                        return ListView(
                                          padding: const EdgeInsets.symmetric(vertical: 16),
                                          shrinkWrap: true,
                                          children: [
                                            if (widget.snap['profileUid'] == profile!.profileUid)
                                              InkWell(
                                                onTap: () {
                                                  _profileBottomSheet(context, setState);
                                                },
                                                child: Container(
                                                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                                  child: const Text(
                                                    'Edit',
                                                  ),
                                                ),
                                              ),
                                            widget.snap['profileUid'] == profile.profileUid
                                                ? InkWell(
                                                    onTap: () async {
                                                      Navigator.of(context).pop();
                                                      showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return AlertDialog(
                                                            title: const Text('Are you sure you want to delete this post?'),
                                                            content: const Text('If you proceed, this post will be permanently deleted.'),
                                                            actions: [
                                                              TextButton(
                                                                onPressed: () {
                                                                  FirestoreMethods().deletePost(widget.snap['postId']);
                                                                  Navigator.of(context).pop();
                                                                },
                                                                child: const Text('Delete', style: TextStyle(fontSize: 16, color: Colors.red)),
                                                              ),
                                                              TextButton(
                                                                onPressed: () {
                                                                  Navigator.of(context).pop();
                                                                },
                                                                child: const Text(
                                                                  'Cancel',
                                                                  style: TextStyle(fontSize: 16),
                                                                ),
                                                              )
                                                            ],
                                                          );
                                                        },
                                                      );
                                                    },
                                                    child: Container(
                                                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                                      child: const Text('Delete'),
                                                    ),
                                                  )
                                                : InkWell(
                                                    onTap: () async {
                                                      Navigator.pop(context);
                                                      FirestoreMethods().blockUser(profile.profileUid, widget.snap['profileUid']);
                                                    },
                                                    child: Container(
                                                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                                      child: const Text('Block User'),
                                                    ),
                                                  ),
                                          ],
                                        );
                                      }),
                                    ),
                                  ),
                                );
                              },
                              child: Icon(
                                Icons.more_vert,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      )),
                    ],
                  ),
                ),
                //CAROUSEL
                Positioned(
                  bottom: 8,
                  left: 0,
                  right: 0,
                  child: PrizesCarouselSlider(
                    likes: widget.snap['likes'],
                    fish: widget.snap['fish'],
                    bones: widget.snap['bones'],
                    profileUid: profile!.profileUid,
                    postId: widget.snap['postId'],
                    controller: _controller,
                  ),
                )
              ],
            ),
            //DESCRIPTION AND COMMENTS
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.only(
                      top: 8,
                    ),
                    child: RichText(
                      text: TextSpan(style: TextStyle(color: theme.colorScheme.primary), children: [
                        TextSpan(
                          text: profileDocs == null ? "" : profileDocs['username'],
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        TextSpan(text: ' ${widget.snap['description']}', style: const TextStyle(fontSize: 15))
                      ]),
                    ),
                  ),
                  // SHOW NUMBER OF COMMENTS
                  InkWell(
                    onTap: () => context.pushNamed(
                      AppRouter.commentsFromFeed.name,
                      extra: widget.snap,
                      pathParameters: {
                        'postId': widget.snap['postId'],
                        'profileUid': widget.snap['profileUid'],
                        'username': profileDocs['username'],
                      },
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Text(
                        'View all $commentLen comments',
                        style: TextStyle(
                          fontSize: 15,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      DateFormat.yMMMd().format(widget.snap['datePublished'].toDate()),
                      style: TextStyle(fontSize: 12, color: theme.colorScheme.primary),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  //EDIT POST BOTTOM SHEET
  void _profileBottomSheet(BuildContext context, StateSetter setState) {
    final ThemeData theme = Theme.of(context);
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      context: context,
      isScrollControlled: true,
      builder: ((context) {
        return Padding(
          padding: ResponsiveLayout.isWeb(context) ? EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / 3) : EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: SizedBox(
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: SafeArea(
                child: Container(
                  padding: const EdgeInsets.all(50),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFieldInput(
                        labelText: 'Change description',
                        textInputType: TextInputType.text,
                        textEditingController: _descriptionController,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      InkWell(
                        onTap: () async {
                          updatePost(setState).then((value) {
                            if (value != 'Post updated succesfully') {
                              showSnackBar(value, context);
                            } else {
                              Navigator.of(context).pop();

                              context.goNamed(AppRouter.feedScreen.name);
                            }
                          });
                        },
                        child: Container(
                          width: double.infinity,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: ShapeDecoration(
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(4)),
                              ),
                              color: theme.colorScheme.secondary),
                          child: _isLoading
                              ? Center(
                                  child: CircularProgressIndicator(
                                    color: theme.colorScheme.primary,
                                  ),
                                )
                              : const Text('Update Post'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
