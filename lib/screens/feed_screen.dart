import 'dart:async';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:pets_social/models/profile.dart';
import 'package:pets_social/providers/chat/chat_provider.dart';
import 'package:pets_social/providers/post/post_provider.dart';
import 'package:pets_social/providers/profile/profile_provider.dart';
import 'package:pets_social/providers/user/user_provider.dart';
import 'package:pets_social/services/firestore_methods.dart';
import 'package:pets_social/responsive/responsive_layout_screen.dart';
import 'package:pets_social/widgets/bottom_sheet.dart';

import '../features/app_router.dart';
import '../utils/utils.dart';
import '../widgets/post_card.dart';
import '../widgets/text_field_input.dart';

class FeedScreen extends ConsumerStatefulWidget {
  const FeedScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FeedScreenState();
}

class _FeedScreenState extends ConsumerState<FeedScreen> {
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
      await ref.read(userProvider.notifier).refreshProfile();
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
    await ref.read(userProvider.notifier).refreshProfile();
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
    final ModelProfile? profile = ref.watch(userProvider);
    final postsState = ref.watch(getFeedPostsProvider(profile));
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      drawer: _drawer(),
      appBar: ResponsiveLayout.isWeb(context) ? null : _appBar(),
      body: LayoutBuilder(builder: (context, constraints) {
        return LiquidPullToRefresh(
            key: _refreshIndicatorKey,
            onRefresh: _handleRefresh,
            showChildOpacityTransition: false,
            animSpeedFactor: 4,
            color: const Color.fromARGB(255, 48, 48, 48),
            backgroundColor: theme.colorScheme.background,
            child: postsState.when(
              loading: () => Center(
                child: CircularProgressIndicator(color: theme.colorScheme.secondary),
              ),
              error: (error, stackTrace) => Text('Error: $error'),
              data: (posts) {
                if (posts.isEmpty) {
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
                  itemCount: posts.length,
                  itemBuilder: (context, index) => Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: ResponsiveLayout.isWeb(context) ? width * 0.37 : 0,
                      vertical: ResponsiveLayout.isWeb(context) ? 15 : 0,
                    ),
                    child: PostCardExp(
                      snap: posts[index].data(),
                    ),
                  ),
                );
              },
            ));
      }),
    );
  }

  //PROFILE LIST FOR DRAWER
  Widget _buildProfileList() {
    final accountProfiles = ref.watch(getAccountProfilesProvider);
    final ThemeData theme = Theme.of(context);

    return accountProfiles.when(
        error: (error, stackTrace) => Text('Error: $error'),
        loading: () => LinearProgressIndicator(
              color: theme.colorScheme.secondary,
            ),
        data: (accountProfiles) {
          return ListView(
            shrinkWrap: true,
            children: accountProfiles.docs.map<Widget>((doc) => _buildProfileListItem(doc)).toList(),
          );
        });
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
      selected: ref.read(userProvider)!.profileUid == data['profileUid'],
      selectedTileColor: theme.colorScheme.secondary,
      onTap: () {
        setState(() {
          ref.read(userProvider.notifier).refreshProfile(profileUid: data['profileUid']);
        });
        Navigator.of(context).pop();
      },
    );
  }

  Widget _drawer() {
    final ThemeData theme = Theme.of(context);

    return Drawer(
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
    );
  }

  PreferredSizeWidget _appBar() {
    final ModelProfile? profile = ref.watch(userProvider);

    final chatsState = ref.watch(numberOfUnreadChatsProvider(profile!.profileUid));

    final ThemeData theme = Theme.of(context);
    return AppBar(
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
          icon: chatsState.when(
            loading: () => Center(
              child: CircularProgressIndicator(color: theme.colorScheme.secondary),
            ),
            error: (error, stackTrace) => Text('Error: $error'),
            data: (chats) {
              return chats > 0
                  ? Badge.count(
                      textColor: Colors.white,
                      backgroundColor: theme.colorScheme.secondary,
                      count: chats,
                      child: const Icon(
                        Icons.forum,
                        size: 25,
                      ),
                    )
                  : const Icon(
                      Icons.forum,
                      size: 25,
                    );
            },
          ),
        ),
      ],
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
