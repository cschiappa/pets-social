import 'dart:async';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:pets_social/models/profile.dart';
import 'package:pets_social/resources/firestore_methods.dart';
import 'package:pets_social/screens/chat/chat_list_page.dart';
import 'package:pets_social/utils/colors.dart';
import 'package:pets_social/utils/global_variables.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../responsive/mobile_screen_layout.dart';
import '../responsive/responsive_layout_screen.dart';
import '../responsive/web_screen_layout.dart';
import '../utils/utils.dart';
import '../widgets/post_card_exp.dart';
import '../widgets/text_field_input.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final GlobalKey<LiquidPullToRefreshState> _refreshIndicatorKey =
      GlobalKey<LiquidPullToRefreshState>();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  Uint8List? _image;
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _bioController.dispose();
    _usernameController.dispose();
  }

  void selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Provider.of<UserProvider>(context, listen: false).refreshProfile();
    });
  }

  Future<void> _handleRefresh() async {
    await Provider.of<UserProvider>(context, listen: false).refreshProfile();
    return await Future.delayed(const Duration(milliseconds: 500));
  }

  void createProfile() async {
    setState(() {
      _isLoading = true;
    });
    String res = await FirestoreMethods().createProfile(
      username: _usernameController.text,
      bio: _bioController.text,
      file: _image,
      uid: FirebaseAuth.instance.currentUser!.uid,
    );

    setState(() {
      _isLoading = false;
    });

    Navigator.of(context).pop();
    if (res != 'success') {
      showSnackBar(res, context);
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    final ModelProfile? profile = Provider.of<UserProvider>(context).getProfile;

    return Scaffold(
      resizeToAvoidBottomInset: false,
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
          _buildProfileList(),
          ListTile(
            tileColor: Colors.grey[500],
            title: Text('Add a New Pet Profile'),
            trailing: Icon(Icons.add_box),
            onTap: () {
              _profileBottomSheet(context);
            },
          )
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
          child: profile!.following.isNotEmpty
              ? StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('posts')
                      .where('profileUid', whereIn: [
                    ...profile.following,
                    profile.profileUid
                  ]).snapshots(),
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

                    // Filter the posts to exclude those from blocked users.
                    final filteredPosts = snapshot.data!.docs.where((doc) {
                      return !profile.blockedUsers.contains(doc['profileUid']);
                    }).toList();

                    // POST CARD
                    return ListView.builder(
                      itemCount: filteredPosts.length,
                      itemBuilder: (context, index) => Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: width > webScreenSize ? width * 0.3 : 0,
                          vertical: width > webScreenSize ? 15 : 0,
                        ),
                        child: PostCardExp(
                          snap: filteredPosts[index].data(),
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

  //build list of profiles for drawer
  Widget _buildProfileList() {
    final ModelProfile? profile = Provider.of<UserProvider>(context).getProfile;

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('profiles')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('error');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: pinkColor),
          );
        }

        return ListView(
          shrinkWrap: true,
          children: snapshot.data!.docs
              .map<Widget>((doc) => _buildProfileListItem(doc))
              .toList(),
        );
      },
    );
  }

  Widget _buildProfileListItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

    return ListTile(
      leading: Container(
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2)),
        child: CircleAvatar(
          radius: 20,
          backgroundImage: NetworkImage(data['photoUrl'] ?? ""),
        ),
      ),
      title: Text(data['username']),
      onTap: () {},
    );
  }

  void _profileBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: ((context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: SizedBox(
            child: GestureDetector(
              onTap: () {
                // Close the keyboard when tapping outside the text fields
                FocusScope.of(context).unfocus();
              },
              child: SafeArea(
                child: Container(
                  padding: const EdgeInsets.all(50),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Stack(
                        children: [
                          _image != null
                              ? CircleAvatar(
                                  radius: 40,
                                  backgroundImage: MemoryImage(_image!),
                                )
                              : const CircleAvatar(
                                  radius: 40,
                                  backgroundImage: NetworkImage(
                                    'https://i.pinimg.com/474x/eb/bb/b4/ebbbb41de744b5ee43107b25bd27c753.jpg',
                                  )),
                          Positioned(
                            top: 40,
                            left: 40,
                            child: IconButton(
                              iconSize: 20,
                              onPressed: selectImage,
                              icon: const Icon(
                                Icons.add_a_photo,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFieldInput(
                        hintText: 'Enter your username',
                        textInputType: TextInputType.text,
                        textEditingController: _usernameController,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFieldInput(
                        hintText: 'Enter your bio',
                        textInputType: TextInputType.text,
                        textEditingController: _bioController,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      InkWell(
                        onTap: () => createProfile(),
                        child: Container(
                          width: double.infinity,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: const ShapeDecoration(
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(4)),
                              ),
                              color: pinkColor),
                          child: _isLoading
                              ? const Center(
                                  child: CircularProgressIndicator(
                                    color: primaryColor,
                                  ),
                                )
                              : const Text('Create Profile'),
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
