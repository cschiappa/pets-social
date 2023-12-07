import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:pets_social/resources/firestore_methods.dart';
import 'package:pets_social/widgets/bone_animation.dart';
import 'package:pets_social/widgets/fish_animation.dart';
import 'package:pets_social/widgets/like_animation.dart';

class PrizesCarouselSlider extends StatefulWidget {
  final List likes;
  final List fish;
  final List bones;
  final String profileUid;
  final String postId;
  final CarouselController controller;
  const PrizesCarouselSlider({super.key, required this.likes, required this.fish, required this.bones, required this.profileUid, required this.postId, required this.controller});

  @override
  State<PrizesCarouselSlider> createState() => _PrizesCarouselSliderState();
}

class _PrizesCarouselSliderState extends State<PrizesCarouselSlider> {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 90),
      child: Container(
        padding: const EdgeInsets.all(2.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: const Color.fromARGB(100, 0, 0, 0),
        ),
        child: Row(
          children: [
            //ARROW LEFT SWIPE
            InkWell(
              onTap: () {
                widget.controller.previousPage();
              },
              child: Icon(
                Icons.arrow_left,
                color: theme.colorScheme.primary,
              ),
            ),
            Expanded(
              child: CarouselSlider(
                carouselController: widget.controller,
                options: CarouselOptions(
                  viewportFraction: 0.4,
                  aspectRatio: 4,
                  enableInfiniteScroll: true,
                  initialPage: 1,
                  enlargeCenterPage: true,
                  enlargeFactor: 0.5,
                  enlargeStrategy: CenterPageEnlargeStrategy.zoom,
                ),
                items: [
                  // FISH
                  FishAnimation(
                    isAnimating: widget.fish.contains(widget.profileUid),
                    smallLike: true,
                    child: InkWell(
                      onTap: () async {
                        await FirestoreMethods().giveFishToPost(widget.postId, widget.profileUid, widget.fish);
                      },
                      child: Image.asset(
                        (widget.fish.contains(widget.profileUid)) ? 'assets/fish.png' : 'assets/fish_border.png',
                      ),
                    ),
                  ),
                  //LIKES
                  LikeAnimation(
                    isAnimating: widget.likes.contains(widget.profileUid),
                    smallLike: true,
                    child: InkWell(
                      onTap: () async {
                        await FirestoreMethods().likePost(widget.postId, widget.profileUid, widget.likes);
                      },
                      child: Image.asset(
                        (widget.likes.contains(widget.profileUid)) ? 'assets/like.png' : 'assets/like_border.png',
                      ),
                    ),
                  ),
                  //BONES
                  BoneAnimation(
                    isAnimating: widget.bones.contains(widget.profileUid),
                    smallLike: true,
                    child: InkWell(
                      onTap: () async {
                        await FirestoreMethods().giveBoneToPost(widget.postId, widget.profileUid, widget.bones);
                      },
                      child: Image.asset(
                        (widget.bones.contains(widget.profileUid)) ? 'assets/bone.png' : 'assets/bone_border.png',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            //ARROW RIGHT SWIPE
            InkWell(
              onTap: () {
                widget.controller.nextPage();
              },
              child: Icon(Icons.arrow_right, color: theme.colorScheme.primary),
            ),
          ],
        ),
      ),
    );
  }
}
