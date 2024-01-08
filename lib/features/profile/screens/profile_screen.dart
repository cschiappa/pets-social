import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pets_social/core/widgets/follow_button.dart';
import 'package:pets_social/core/widgets/text_field_input.dart';
import 'package:pets_social/features/auth/controller/auth_provider.dart';
import 'package:pets_social/features/post/controller/post_provider.dart';
import 'package:pets_social/features/profile/controller/profile_provider.dart';
import 'package:pets_social/models/profile.dart';
import 'package:pets_social/router.dart';
import 'package:pets_social/models/post.dart';

import 'package:pets_social/features/auth/repository/auth_repository.dart';
import 'package:pets_social/features/post/repository/post_repository.dart';
import 'package:pets_social/responsive/responsive_layout_screen.dart';
import 'package:pets_social/core/utils.dart';
import 'package:pets_social/core/widgets/bottom_sheet.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  final String? profileUid;
  final dynamic snap;

  const ProfileScreen({super.key, this.profileUid, this.snap});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  late String userId = "";
  late TextEditingController _bioController = TextEditingController();
  late TextEditingController _usernameController = TextEditingController();
  Uint8List? _image;
  final bool _isLoading = false;
  final List<String> settingsOptions = ['Saved Posts', 'Settings'];

  //SELECT IMAGE
  void selectImage(context, setState) async {
    Uint8List im;
    (im, _, _, _) = await pickImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }

  //FIELD VALUES
  void fieldsValues() {
    final ModelProfile? profile = ref.read(userProvider);
    _usernameController = TextEditingController(text: profile!.username);
    _bioController = TextEditingController(text: profile.bio);
  }

  @override
  void dispose() {
    _bioController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  //RESET FIELDS FUNCTION
  void resetFields() {
    _usernameController.text = _usernameController.text;
    _bioController.text = _bioController.text;
    setState(() {
      _image = _image;
    });
  }

  //EDIT PROFILE FUNCTION
  void updateProfile() async {
    final ModelProfile? profile = ref.read(userProvider);
    try {
      ref.read(
        updateProfileProvider(profile!.profileUid, _image, _usernameController.text, _bioController.text),
      );
      showSnackBar('Success!', context);
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ModelProfile? profile = ref.watch(userProvider);
    final ThemeData theme = Theme.of(context);
    userId = widget.profileUid ?? profile!.profileUid;
    final profileData = ref.watch(getProfileDataProvider(userId));
    final profilePosts = ref.watch(getProfilePostsProvider(userId));

    return profileData.when(
      error: (error, stackTrace) => Text('Error: $error'),
      loading: () => Center(
        child: CircularProgressIndicator(
          color: theme.colorScheme.secondary,
        ),
      ),
      data: (profileData) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: theme.appBarTheme.backgroundColor,
            //APPBAR ROW
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(profileData.username),
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => Dialog(
                        child: ListView(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shrinkWrap: true,
                          children: settingsOptions
                              .map(
                                (e) => InkWell(
                                  onTap: () {
                                    if (e == 'Saved Posts') {
                                      Navigator.pop(context);

                                      context.goNamed(AppRouter.savedPosts.name, extra: widget.snap);
                                    } else if (e == 'Settings') {
                                      Navigator.pop(context);

                                      context.goNamed(AppRouter.settings.name);
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                    child: Text(e),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.more_vert),
                ),
              ],
            ),
            centerTitle: false,
          ),
          body: Container(
            padding: ResponsiveLayout.isWeb(context) ? EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / 3) : const EdgeInsets.symmetric(horizontal: 0),
            child: Stack(
              children: [
                //GRADIENT CONTAINER
                Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10.0),
                      bottomRight: Radius.circular(10.0),
                    ),
                    gradient: LinearGradient(
                      colors: [
                        Color.fromARGB(255, 157, 110, 157), // Start color
                        Color.fromARGB(255, 240, 177, 136), // End color
                      ],
                    ),
                  ),
                  alignment: Alignment.topCenter,
                  height: 60,
                ),
                ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          //PROFILE PIC
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: theme.colorScheme.background,
                                width: 5.0,
                              ),
                            ),
                            child: CircleAvatar(
                              backgroundImage: NetworkImage(
                                profileData.photoUrl ?? '',
                              ),
                              radius: 40,
                            ),
                          ),
                          //USERNAME
                          Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.only(top: 10),
                            child: Text(
                              profileData.username,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          //DESCRIPTION
                          Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.only(top: 10),
                            child: Text(
                              profileData.bio ?? '',
                            ),
                          ),
                          //PROFILE STATS ROW
                          profileStats(profileData.followers.length),
                          //SIGN OUT/FOLLOW BUTTON AND SETTINGS WHEEL
                          signOutButtonAndSettingsRow(profile, theme, profileData),
                        ],
                      ),
                    ),
                    const Divider(),
                    //PICTURES GRID
                    profilePosts.when(
                        error: (error, stacktrace) => Text('error: $error'),
                        loading: () => Center(
                              child: CircularProgressIndicator(
                                color: theme.colorScheme.secondary,
                              ),
                            ),
                        data: (profilePosts) {
                          return GridView.builder(
                            shrinkWrap: true,
                            itemCount: profilePosts.docs.length,
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 5, mainAxisSpacing: 1.5, childAspectRatio: 1),
                            itemBuilder: (context, index) {
                              ModelPost post = ModelPost.fromSnap(profilePosts.docs[index]);

                              Widget mediaWidget;
                              final String contentType = getContentTypeFromUrl(post.fileType);
                              //return video
                              if (contentType == 'video') {
                                mediaWidget = ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: Image(
                                    image: NetworkImage(post.videoThumbnail),
                                    fit: BoxFit.cover,
                                  ),
                                );
                              } else {
                                // return image
                                mediaWidget = ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: Image(
                                    image: NetworkImage(post.postUrl),
                                    fit: BoxFit.cover,
                                  ),
                                );
                              }
                              return GestureDetector(
                                onTap: () {
                                  post.profileUid == profile!.profileUid
                                      ? context.goNamed(
                                          AppRouter.openPostFromProfile.name,
                                          pathParameters: {
                                            'postId': post.postId,
                                            'profileUid': post.profileUid,
                                            'username': profileData.username,
                                          },
                                        )
                                      : context.goNamed(
                                          AppRouter.openPostFromFeed.name,
                                          pathParameters: {
                                            'postId': post.postId,
                                            'profileUid': post.profileUid,
                                            'username': profileData.username,
                                          },
                                        );
                                },
                                child: mediaWidget,
                              );
                            },
                          );
                        }),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  //PROFILE STATS ROW
  Widget profileStats(followers) {
    final profilePosts = ref.read(getProfilePostsProvider(userId));
    return profilePosts.when(
      data: (profilePosts) {
        int likes = 0;
        int fish = 0;
        int bones = 0;

        for (var post in profilePosts.docs) {
          likes += post.data()['likes'].length as int;
          fish += post.data()['fish'].length as int;
          bones += post.data()['bones'].length as int;
        }

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            buildStatColumn(likes, "likes"),
            buildStatColumn(fish, "fish"),
            buildStatColumn(bones, "bones"),
            buildStatColumn(followers, "followers"),
          ],
        );
      },
      loading: () => Container(),
      error: (error, stackTrace) => Text("Error: $error"),
    );
  }

  //SIGNOUT/FOLLOW BUTTON AND SETTINGS WHEEL
  Widget signOutButtonAndSettingsRow(ModelProfile? profile, ThemeData theme, ModelProfile profileData) {
    final authRepository = ref.read(authRepositoryProvider);
    bool isFollowing = profileData.followers.contains(profile!.profileUid);
    return Row(
      mainAxisAlignment: profileData.profileUid == profile.profileUid ? MainAxisAlignment.end : MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            profile.profileUid == userId
                ? FollowButton(
                    text: 'Sign Out',
                    backgroundColor: theme.colorScheme.background,
                    textColor: theme.colorScheme.tertiary,
                    borderColor: Colors.grey,
                    function: () async {
                      await authRepository.signOut(context).then((value) => ref.read(userProvider.notifier).disposeProfile());
                      if (!mounted) return;

                      context.goNamed(AppRouter.login.name);
                    },
                  )
                : isFollowing
                    ? FollowButton(
                        text: 'Unfollow',
                        backgroundColor: Colors.white,
                        textColor: Colors.black,
                        borderColor: Colors.grey,
                        function: () async {
                          ref.watch(userProvider.notifier).updateFollowProfiles(profile.profileUid, profileData.profileUid);
                        },
                      )
                    : FollowButton(
                        text: 'Follow',
                        backgroundColor: theme.colorScheme.secondary,
                        textColor: Colors.white,
                        borderColor: theme.colorScheme.secondary,
                        function: () async {
                          ref.watch(userProvider.notifier).updateFollowProfiles(profile.profileUid, profileData.profileUid);
                        },
                      ),
          ],
        ),
        if (profileData.profileUid == profile.profileUid)
          IconButton(
              onPressed: () {
                _profileBottomSheet(context);
              },
              icon: const Icon(
                Icons.settings,
                size: 20,
              ))
      ],
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

  //EDIT PROFILE BOTTOM SHEET
  _profileBottomSheet(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    fieldsValues();
    return CustomBottomSheet.show(
      context: context,
      listWidget: [
        StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
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
                  onTap: () {
                    updateProfile();
                    Navigator.of(context).pop();

                    context.goNamed(AppRouter.profileScreen.name);
                  },
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
                              color: theme.colorScheme.primary,
                            ),
                          )
                        : const Text('Update Profile'),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
