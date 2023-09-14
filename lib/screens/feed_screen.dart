import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:pets_social/models/user.dart';
import 'package:pets_social/screens/chat/chat_list_page.dart';
import 'package:pets_social/utils/colors.dart';
import 'package:pets_social/utils/global_variables.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../widgets/post_card_exp.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final GlobalKey<LiquidPullToRefreshState> _refreshIndicatorKey =
      GlobalKey<LiquidPullToRefreshState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Provider.of<UserProvider>(context, listen: false).refreshUser();
    });
  }

  Future<void> _handleRefresh() async {
    await Provider.of<UserProvider>(context, listen: false).refreshUser();
    return await Future.delayed(const Duration(milliseconds: 500));
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    final User? user = Provider.of<UserProvider>(context).getUser;

    return Scaffold(
      drawer: Drawer(
        backgroundColor: mobileBackgroundColor,
        width: 280,
        child: ListView(children: [
          Container(
            height: 73,
            child: DrawerHeader(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20.0),
                ),
                gradient: LinearGradient(
                  colors: [
                    Color.fromARGB(255, 157, 110, 157), // Start color
                    Color.fromARGB(255, 240, 177, 136), // End color
                  ],
                ),
              ),
              child: Image.asset(
                'assets/logo.png',
                color: primaryColor,
                scale: 6.5,
                alignment: Alignment.topCenter,
              ),
            ),
          ),
          ListTile(
            leading: Container(
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2)),
              child: const CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(
                    'https://i.natgeofe.com/n/548467d8-c5f1-4551-9f58-6817a8d2c45e/NationalGeographic_2572187_square.jpg'),
              ),
            ),
            title: Text(
              'profile',
              style: TextStyle(fontSize: 15),
            ),
          ),
        ]),
      ),
      appBar: width > webScreenSize
          ? null
          : AppBar(
              leading: Builder(builder: (context) {
                return IconButton(
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                  icon: const Icon(
                    Icons.groups,
                  ),
                );
              }),
              backgroundColor: mobileBackgroundColor,
              centerTitle: true,
              title: Image.asset(
                'assets/logo.png',
                color: primaryColor,
                alignment: Alignment.topCenter,
                scale: 6.5,
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const ChatList(),
                    ));
                  },
                  icon: const Icon(
                    Icons.forum,
                    size: 20,
                  ),
                ),
              ],
            ),
      body: LayoutBuilder(builder: (context, constraints) {
        return LiquidPullToRefresh(
          key: _refreshIndicatorKey,
          onRefresh: _handleRefresh,
          showChildOpacityTransition: false,
          animSpeedFactor: 4,
          color: const Color.fromARGB(255, 48, 48, 48),
          backgroundColor: Colors.black,
          child: user!.following.isNotEmpty
              ? StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('posts')
                      .where('uid', whereIn: [...user.following, user.uid])
                      // .where('uid', whereNotIn: user.blockedUsers)
                      .snapshots(),
                  builder: (context,
                      AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
                          snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: pinkColor,
                        ),
                      );
                    }
                    // POST CARD
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) => Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: width > webScreenSize ? width * 0.3 : 0,
                          vertical: width > webScreenSize ? 15 : 0,
                        ),
                        child: PostCardExp(
                          snap: snapshot.data!.docs[index].data(),
                        ),
                      ),
                    );
                  },
                )
              : SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                        minWidth: constraints.maxWidth),
                    child: const Center(
                      child: Text('Follow someone to see posts'),
                    ),
                  ),
                ),
        );
      }),
    );
  }
}
