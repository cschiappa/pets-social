import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pets_social/utils/colors.dart';
import 'package:provider/provider.dart';

import '../models/profile.dart';
import '../providers/user_provider.dart';
import '../utils/utils.dart';

class PrizesScreen extends StatefulWidget {
  const PrizesScreen({super.key});

  @override
  State<PrizesScreen> createState() => _PrizesScreenState();
}

class _PrizesScreenState extends State<PrizesScreen> {
  @override
  Widget build(BuildContext context) {
    final ModelProfile? profile = Provider.of<UserProvider>(context).getProfile;
    var userData = {};
    int postLen = 0;
    int likes = 0;
    int fish = 0;
    int bones = 0;
    int followers = 0;
    bool isFollowing = false;
    bool isLoading = false;
    String userId = "";
    final CarouselController _controller = CarouselController();

    getData() async {
      final ModelProfile? profile =
          Provider.of<UserProvider>(context, listen: false).getProfile;
      setState(() {
        isLoading = true;
      });
      try {
        var userSnap = await FirebaseFirestore.instance
            .collectionGroup('profiles')
            .where('profileUid', isEqualTo: userId)
            .get();

        //GET POST LENGTH
        var postSnap = await FirebaseFirestore.instance
            .collection('posts')
            .where('profileUid', isEqualTo: profile!.profileUid)
            .get();

        postLen = postSnap.docs.length;
        userData = userSnap.docs.first.data();
        followers = userData['followers'].length;
        isFollowing = userData['followers'].contains(profile.profileUid);

        for (var post in postSnap.docs) {
          likes += post.data()['likes'].length as int;
          fish += post.data()['fish'].length as int;
          bones += post.data()['bones'].length as int;
        }
      } catch (e) {
        showSnackBar(
          e.toString(),
          context,
        );
      }
      setState(() {
        isLoading = false;
      });
    }

    return Scaffold(
        body: Column(
      children: [
        SizedBox(
          height: 60,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.all(20),
              child: RichText(
                text: TextSpan(
                  style: DefaultTextStyle.of(context).style,
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Hello ${profile!.username}\n',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: 'How are you feeling today?',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: CircleAvatar(
                backgroundImage: (profile.photoUrl != null)
                    ? NetworkImage(profile.photoUrl!)
                    : AssetImage('assets/default_pic') as ImageProvider<Object>,
              ),
            ),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        Container(
          padding: EdgeInsets.all(20),
          width: double.infinity,
          height: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 157, 110, 157), // Start color
                Color.fromARGB(255, 240, 177, 136), // End color
              ],
            ),
          ),
          child: Text(
            'Notifications',
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Container(
            padding: EdgeInsets.all(20),
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 157, 110, 157), // Start color
                  Color.fromARGB(255, 240, 177, 136), // End color
                ],
              ),
            ),
            child: Column(
              children: [
                Text('Prizes'),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 90),
                  child: Container(
                    padding: EdgeInsets.all(2.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Color.fromARGB(100, 0, 0, 0),
                    ),
                    child: Row(
                      children: [
                        //ARROW LEFT SWIPE
                        InkWell(
                          onTap: () {
                            _controller.previousPage();
                          },
                          child: const Icon(
                            Icons.arrow_left,
                          ),
                        ),
                        Expanded(
                          child: CarouselSlider(
                            carouselController: _controller,
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
                              Image.asset(
                                (fish == 0)
                                    ? 'assets/fish.png'
                                    : 'assets/fish_border.png',
                                width: 100,
                                height: 100,
                              ),

                              //LIKES
                              Image.asset(
                                (likes == 0)
                                    ? 'assets/like.png'
                                    : 'assets/like_border.png',
                                width: 100,
                                height: 100,
                              ),

                              //BONES
                              Image.asset(
                                (bones == 0)
                                    ? 'assets/bone.png'
                                    : 'assets/bone_border.png',
                                width: 100,
                                height: 100,
                              ),
                            ],
                          ),
                        ),
                        //ARROW RIGHT SWIPE
                        InkWell(
                          onTap: () {
                            _controller.nextPage();
                          },
                          child: const Icon(
                            Icons.arrow_right,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ))
      ],
    ));
  }
}
