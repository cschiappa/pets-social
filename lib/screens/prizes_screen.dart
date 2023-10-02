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
  var userData = {};
  int postLen = 0;
  int likes = 0;
  int fish = 0;
  int bones = 0;
  int followers = 0;
  int following = 0;
  bool isFollowing = false;
  bool isLoading = false;
  final CarouselController _controller = CarouselController();

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    final ModelProfile? profile =
        Provider.of<UserProvider>(context, listen: false).getProfile;
    setState(() {
      isLoading = true;
    });
    try {
      var userSnap = await FirebaseFirestore.instance
          .collectionGroup('profiles')
          .where('profileUid', isEqualTo: profile!.profileUid)
          .get();

      //GET POST LENGTH
      var postSnap = await FirebaseFirestore.instance
          .collection('posts')
          .where('profileUid', isEqualTo: profile.profileUid)
          .get();

      postLen = postSnap.docs.length;
      userData = userSnap.docs.first.data();
      followers = userData['followers'].length;
      following = userData['following'].length;
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

  @override
  Widget build(BuildContext context) {
    final ModelProfile? profile = Provider.of<UserProvider>(context).getProfile;
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 50,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                alignment: Alignment.topLeft,
                padding: EdgeInsets.all(15),
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
                      : AssetImage('assets/default_pic')
                          as ImageProvider<Object>,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            alignment: Alignment.topLeft,
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Notifications',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    Icon(Icons.notification_add)
                  ],
                ),
                Divider(
                  color: Colors.white,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.all(20),
              width: double.infinity,
              height: 120,
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
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    alignment: Alignment.topLeft,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Stats',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        Icon(Icons.query_stats)
                      ],
                    ),
                  ),
                  Divider(
                    color: Colors.white,
                  ),
                  Container(
                    alignment: Alignment.topLeft,
                    child: Column(
                      children: [
                        Text('$followers followers'),
                        Text('$following following'),
                      ],
                    ),
                  )
                ],
              )),
          SizedBox(
            height: 20,
          ),
          Container(
              padding: EdgeInsets.all(20),
              width: double.infinity,
              height: 250,
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
                  Container(
                    alignment: Alignment.topLeft,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Prizes',
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        Icon(Icons.emoji_events)
                      ],
                    ),
                  ),
                  Divider(
                    color: Colors.white,
                  ),
                  Container(
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
                              aspectRatio: 2,
                              enableInfiniteScroll: true,
                              initialPage: 1,
                              enlargeCenterPage: true,
                              enlargeFactor: 0.5,
                              enlargeStrategy: CenterPageEnlargeStrategy.zoom,
                            ),
                            items: [
                              // FISH
                              Column(
                                children: [
                                  Image.asset(
                                    (fish > 0)
                                        ? 'assets/fish.png'
                                        : 'assets/fish_border.png',
                                    width: 100,
                                    height: 100,
                                  ),
                                  Text('$fish fish')
                                ],
                              ),

                              //LIKES
                              Column(
                                children: [
                                  Image.asset(
                                    (likes > 0)
                                        ? 'assets/like.png'
                                        : 'assets/like_border.png',
                                    width: 100,
                                    height: 100,
                                  ),
                                  Text((likes == 1)
                                      ? '$likes like'
                                      : '$likes likes')
                                ],
                              ),

                              //BONES
                              Column(
                                children: [
                                  Image.asset(
                                    (bones > 0)
                                        ? 'assets/bone.png'
                                        : 'assets/bone_border.png',
                                    width: 100,
                                    height: 100,
                                  ),
                                  Text((bones == 1)
                                      ? '$bones bone'
                                      : '$bones bones')
                                ],
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
                ],
              ))
        ],
      ),
    ));
  }
}
