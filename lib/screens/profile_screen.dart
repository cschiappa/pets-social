import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pets_social/resources/auth_methods.dart';
import 'package:pets_social/resources/firestore_methods.dart';
import 'package:pets_social/screens/login_screen.dart';
import 'package:pets_social/utils/colors.dart';
import 'package:pets_social/utils/utils.dart';

import '../widgets/follow_button.dart';

class ProfileScreen extends StatefulWidget {
  final String? uid;
  const ProfileScreen({super.key, this.uid});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userData = {};
  int postLen = 0;
  int likes = 0;
  int fish = 0;
  int bones = 0;
  int followers = 0;
  bool isFollowing = false;
  bool isLoading = false;
  String userId = "";

  @override
  void initState() {
    super.initState();
    userId = widget.uid ?? FirebaseAuth.instance.currentUser!.uid;
    getData();
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      //GET POST LENGTH
      var postSnap = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();

      postLen = postSnap.docs.length;
      userData = userSnap.data()!;
      followers = userSnap.data()!['followers'].length;
      isFollowing = userSnap
          .data()!['followers']
          .contains(FirebaseAuth.instance.currentUser!.uid);

      for (var post in postSnap.docs) {
        likes += post.data()['likes'].length as int;
        fish += post.data()['fish'].length as int;
        bones += post.data()['bones'].length as int;
      }

      setState(() {});
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
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              title: Text(userData['username']),
              centerTitle: false,
            ),
            body: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      //PROFILE PIC
                      CircleAvatar(
                        backgroundColor: Colors.grey,
                        backgroundImage: NetworkImage(
                          userData['photoUrl'],
                        ),
                        radius: 40,
                      ),
                      //USERNAME
                      Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(
                          userData['username'],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      //DESCRIPTION
                      Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(
                          userData['bio'],
                        ),
                      ),
                      //PROFILE STATS
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          buildStatColumn(likes, "likes"),
                          buildStatColumn(fish, "fish"),
                          buildStatColumn(bones, "bones"),
                          buildStatColumn(followers, "followers"),
                        ],
                      ),
                      //BUTTON
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          FirebaseAuth.instance.currentUser!.uid == userId
                              ? FollowButton(
                                  text: 'Sign Out',
                                  backgroundColor: mobileBackgroundColor,
                                  textColor: primaryColor,
                                  borderColor: Colors.grey,
                                  function: () async {
                                    await AuthMethods().signOut();
                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const LoginScreen(),
                                      ),
                                    );
                                  },
                                )
                              : isFollowing
                                  ? FollowButton(
                                      text: 'Unfollow',
                                      backgroundColor: Colors.white,
                                      textColor: Colors.black,
                                      borderColor: Colors.grey,
                                      function: () async {
                                        await FirestoreMethods().followUser(
                                          FirebaseAuth
                                              .instance.currentUser!.uid,
                                          userData['uid'],
                                        );
                                        setState(() {
                                          isFollowing = false;
                                          followers--;
                                        });
                                      },
                                    )
                                  : FollowButton(
                                      text: 'Follow',
                                      backgroundColor:
                                          Color.fromRGBO(242, 102, 139, 1),
                                      textColor: Colors.white,
                                      borderColor:
                                          Color.fromRGBO(242, 102, 139, 1),
                                      function: () async {
                                        await FirestoreMethods().followUser(
                                          FirebaseAuth
                                              .instance.currentUser!.uid,
                                          userData['uid'],
                                        );
                                        setState(() {
                                          isFollowing = true;
                                          followers++;
                                        });
                                      },
                                    )
                        ],
                      ),
                      const Divider(),
                      FutureBuilder(
                        future: FirebaseFirestore.instance
                            .collection('posts')
                            .where('uid', isEqualTo: userId)
                            .get(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          return GridView.builder(
                            shrinkWrap: true,
                            itemCount: (snapshot.data! as dynamic).docs.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 5,
                                    mainAxisSpacing: 1.5,
                                    childAspectRatio: 1),
                            itemBuilder: (context, index) {
                              DocumentSnapshot snap =
                                  (snapshot.data! as dynamic).docs[index];

                              return Container(
                                child: Image(
                                  image: NetworkImage(snap['postUrl']),
                                  fit: BoxFit.cover,
                                ),
                              );
                            },
                          );
                        },
                      )
                    ],
                  ),
                )
              ],
            ),
          );
  }

  //PROFILE STATS FUNCTION
  Column buildStatColumn(int num, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 10),
          child: Text(
            num.toString(),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
