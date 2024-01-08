import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:pets_social/features/post/controller/post_provider.dart';
import 'package:pets_social/features/profile/controller/profile_provider.dart';
import 'package:pets_social/router.dart';

import '../../models/profile.dart';
import 'like_animation.dart';

class CommentCard extends ConsumerStatefulWidget {
  final dynamic snap;
  const CommentCard({super.key, required this.snap});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CommentCardState();
}

class _CommentCardState extends ConsumerState<CommentCard> {
  @override
  Widget build(BuildContext context) {
    final ModelProfile? profile = ref.watch(userProvider);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
      child: Row(children: [
        GestureDetector(
          onTap: () {
            String profileUid = widget.snap['profileUid'];

            context.goNamed(
              AppRouter.profileFromFeed.name,
              pathParameters: {
                'profileUid': profileUid,
              },
            );
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

                        context.goNamed(
                          AppRouter.profileFromFeed.name,
                          pathParameters: {
                            'profileUid': profileUid,
                          },
                        );
                      },
                      child: RichText(
                        text: TextSpan(text: widget.snap['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
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
                    DateFormat.yMMMd().format(widget.snap['datePublished'].toDate()),
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                  ),
                )
              ],
            ),
          ),
        ),
        Consumer(builder: (context, ref, child) {
          final postRepository = ref.read(postRepositoryProvider);
          return LikeAnimation(
            isAnimating: widget.snap['likes'] != null && widget.snap['likes'].contains(profile!.profileUid),
            smallLike: true,
            child: InkWell(
              onTap: () async {
                await postRepository.likeComment(widget.snap['postId'], widget.snap['commentId'], profile!.profileUid, widget.snap['likes']);
              },
              child: Image.asset(
                (widget.snap['likes'] != null && widget.snap['likes'].contains(profile!.profileUid)) ? 'assets/like.png' : 'assets/like_border.png',
                width: 14,
                height: 14,
              ),
            ),
          );
        }),
      ]),
    );
  }
}