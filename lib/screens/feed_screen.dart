import 'dart:async';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:pets_social/models/profile.dart';
import 'package:pets_social/resources/firestore_methods.dart';
import 'package:pets_social/responsive/responsive_layout_screen.dart';
import 'package:pets_social/widgets/bottom_sheet.dart';
import 'package:provider/provider.dart';
import '../features/app_router.dart';
import '../providers/user_provider.dart';
import '../utils/utils.dart';
import '../widgets/post_card.dart';
import '../widgets/text_field_input.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final GlobalKey<LiquidPullToRefreshState> _refreshIndicatorKey = GlobalKey<LiquidPullToRefreshState>();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  Uint8List? _image;
  bool _isLoading = false;

  @override
  void dispose() {
    _bioController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Provider.of<UserProvider>(context, listen: false).refreshProfile();
    });
  }

  //SELECT IMAGE
  void selectImage(context, setState) async {
    Uint8List im;
    (im, _, _, _) = await pickImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }

  //REFRESH PROFILE
  Future<void> _handleRefresh() async {
    await Provider.of<UserProvider>(context, listen: false).refreshProfile();
    return await Future.delayed(const Duration(milliseconds: 500));
  }

  //CREATE NEW PROFILE
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
    if (!mounted) return;
    Navigator.of(context).pop();

    _usernameController.clear();
    _bioController.clear();
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
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      drawer: Drawer(
        backgroundColor: theme.colorScheme.background,
        width: 280,
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(
                height: 73,
                width: double.infinity,
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
                    color: theme.colorScheme.primary,
                    scale: 6.5,
                    alignment: Alignment.topCenter,
                  ),
                ),
              ),
              _buildProfileList(),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: ListTile(
                    tileColor: Colors.grey[500],
                    title: const Text('Add a New Pet Profile'),
                    trailing: const Icon(Icons.person_add),
                    onTap: () {
                      _profileBottomSheet(context);
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      appBar: ResponsiveLayout.isWeb(context)
          ? null
          : AppBar(
              leading: Builder(builder: (context) {
                return IconButton(
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                  icon: const Icon(
                    Icons.groups,
                    size: 30,
                  ),
                );
              }),
              backgroundColor: theme.appBarTheme.backgroundColor,
              centerTitle: true,
              title: Image.asset(
                'assets/logo.png',
                color: theme.colorScheme.tertiary,
                alignment: Alignment.topCenter,
                scale: 6.5,
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    context.goNamed(AppRouter.chatList.name);
                  },
                  icon: FutureBuilder<int>(
                    future: numberOfUnreadChats(profile!.profileUid),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return const Icon(Icons.error);
                      } else {
                        return snapshot.data! > 0
                            ? Badge.count(
                                textColor: Colors.white,
                                backgroundColor: theme.colorScheme.secondary,
                                count: snapshot.data!,
                                child: const Icon(
                                  Icons.forum,
                                  size: 25,
                                ),
                              )
                            : const Icon(
                                Icons.forum,
                                size: 25,
                              );
                      }
                    },
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
            backgroundColor: theme.colorScheme.background,
            child: profile == null
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : StreamBuilder(
                    stream: FirebaseFirestore.instance.collection('posts').where('profileUid', whereIn: [...profile.following, profile.profileUid]).orderBy('datePublished', descending: true).snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(
                            color: theme.colorScheme.secondary,
                          ),
                        );
                      }

                      // Filter the posts to exclude those from blocked users.
                      final filteredPosts = snapshot.data!.docs.where((doc) {
                        return !profile.blockedUsers.contains(doc['profileUid']);
                      }).toList();

                      if (filteredPosts.isEmpty) {
                        return SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(minHeight: constraints.maxHeight, minWidth: constraints.maxWidth),
                            child: const Center(
                              child: Text('Follow someone to see posts'),
                            ),
                          ),
                        );
                      }

                      // POST CARD
                      return ListView.builder(
                        itemCount: filteredPosts.length,
                        itemBuilder: (context, index) => Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: ResponsiveLayout.isWeb(context) ? width * 0.37 : 0,
                            vertical: ResponsiveLayout.isWeb(context) ? 15 : 0,
                          ),
                          child: PostCardExp(
                            snap: filteredPosts[index].data(),
                          ),
                        ),
                      );
                    },
                  ));
      }),
    );
  }

  Future<int> numberOfUnreadChats(String profileUid) async {
    final QuerySnapshot chats = await FirebaseFirestore.instance.collection('chats').where('lastMessage.receiverUid', isEqualTo: profileUid).where('lastMessage.read', isEqualTo: false).get();

    return chats.docs.length;
  }

  //PROFILE LIST FOR DRAWER
  Widget _buildProfileList() {
    final ThemeData theme = Theme.of(context);
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).collection('profiles').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('error');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(color: theme.colorScheme.secondary),
          );
        }

        return ListView(
          shrinkWrap: true,
          children: snapshot.data!.docs.map<Widget>((doc) => _buildProfileListItem(doc)).toList(),
        );
      },
    );
  }

  //PROFILE LIST ITEM FOR DRAWER
  Widget _buildProfileListItem(DocumentSnapshot document) {
    final ThemeData theme = Theme.of(context);
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

    return ListTile(
      leading: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2),
        ),
        child: CircleAvatar(
          radius: 20,
          backgroundImage: NetworkImage(data['photoUrl'] ?? ""),
        ),
      ),
      title: Text(data['username']),
      selected: Provider.of<UserProvider>(context, listen: false).getProfile?.profileUid == data['profileUid'],
      selectedTileColor: theme.colorScheme.secondary,
      onTap: () {
        setState(() {
          Provider.of<UserProvider>(context, listen: false).refreshProfile(profileUid: data['profileUid']);
        });
        Navigator.of(context).pop();
      },
    );
  }

  //CREATE PROFILE BOTTOM SHEET
  void _profileBottomSheet(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return CustomBottomSheet.show(context: context, listWidget: [
      StatefulBuilder(
        builder: (context, setState) {
          return Column(
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
                      onPressed: () => selectImage(context, setState),
                      icon: const Icon(
                        Icons.add_a_photo,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              TextFieldInput(
                labelText: 'Enter your username',
                textInputType: TextInputType.text,
                textEditingController: _usernameController,
              ),
              const SizedBox(
                height: 20,
              ),
              TextFieldInput(
                labelText: 'Enter your bio',
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
                  decoration: ShapeDecoration(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                      ),
                      color: theme.colorScheme.secondary),
                  child: _isLoading
                      ? Center(
                          child: CircularProgressIndicator(
                            color: theme.colorScheme.secondary,
                          ),
                        )
                      : const Text('Create Profile'),
                ),
              ),
            ],
          );
        },
      ),
    ]);
  }
}
