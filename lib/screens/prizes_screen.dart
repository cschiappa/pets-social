import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:pets_social/screens/open_post_screen.dart';
import 'package:pets_social/screens/profile_screen.dart';
import 'package:provider/provider.dart';

import '../models/profile.dart';
import '../providers/user_provider.dart';
import '../utils/global_variables.dart';
import '../utils/utils.dart';

class PrizesScreen extends StatefulWidget {
  const PrizesScreen({super.key});

  @override
  State<PrizesScreen> createState() => _PrizesScreenState();
}

class _PrizesScreenState extends State<PrizesScreen> {
  var notificationData = [];
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

      var notificationSnap = await FirebaseFirestore.instance
          .collection('notifications')
          .where('receiver', isEqualTo: profile.profileUid)
          .get();

      postLen = postSnap.docs.length;
      userData = userSnap.docs.first.data();
      followers = userData['followers'].length;
      following = userData['following'].length;
      isFollowing = userData['followers'].contains(profile.profileUid);
      notificationData =
          notificationSnap.docs.map((doc) => doc.data()).toList();

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
    final message =
        ModalRoute.of(context)!.settings.arguments as RemoteMessage?;
    return Scaffold(
        body: SingleChildScrollView(
      padding: MediaQuery.of(context).size.width > webScreenSize
          ? EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width / 3)
          : const EdgeInsets.symmetric(horizontal: 0),
      child: Column(
        children: [
          const SizedBox(
            height: 50,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.all(15),
                child: RichText(
                  text: TextSpan(
                    style: DefaultTextStyle.of(context).style,
                    children: <TextSpan>[
                      TextSpan(
                        text: 'Hello ${profile!.username}\n',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const TextSpan(
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
                      : const AssetImage('assets/default_pic')
                          as ImageProvider<Object>,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.all(20),
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              gradient: const LinearGradient(
                colors: [
                  Color.fromARGB(255, 157, 110, 157), // Start color
                  Color.fromARGB(255, 240, 177, 136), // End color
                ],
              ),
            ),
            child: Column(
              children: [
                const Row(
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
                const Divider(
                  color: Colors.white,
                ),
                Expanded(
                  child: Scrollbar(
                    thumbVisibility: true,
                    child: ListView.builder(
                        itemCount: notificationData.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              notificationData[index]['postId'] == ""
                                  ? Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => ProfileScreen(
                                          profileUid: notificationData[index]
                                              ['sender'],
                                        ),
                                      ),
                                    )
                                  : Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => OpenPost(
                                            postId: notificationData[index]
                                                ['postId'],
                                            profileUid: notificationData[index]
                                                ['sender'],
                                            username: notificationData[index]
                                                ['postId']),
                                      ),
                                    );
                            },
                            child: ListTile(
                              leading: Text(notificationData[index]['body']),
                            ),
                          );
                        }),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
              alignment: Alignment.topLeft,
              padding: const EdgeInsets.all(20),
              width: double.infinity,
              height: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                gradient: const LinearGradient(
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
                    child: const Row(
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
                  const Divider(
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
          const SizedBox(
            height: 20,
          ),
          Container(
              padding: const EdgeInsets.all(20),
              width: double.infinity,
              height: 250,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.0),
                gradient: const LinearGradient(
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
                    child: const Row(
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
                  const Divider(
                    color: Colors.white,
                  ),
                  SingleChildScrollView(
                    child: Container(
                      // height: MediaQuery.of(context).size.width > webScreenSize
                      //     ? 150
                      //     : 0,
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
                  ),
                ],
              ))
        ],
      ),
    ));
  }
}
