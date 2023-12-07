import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pets_social/features/app_router.dart';
import 'package:pets_social/resources/auth_methods.dart';
import 'package:pets_social/resources/firestore_methods.dart';
import 'package:pets_social/responsive/responsive_layout_screen.dart';
import 'package:pets_social/utils/utils.dart';
import 'package:pets_social/widgets/bottom_sheet.dart';
import 'package:provider/provider.dart';
import '../models/profile.dart';
import '../providers/user_provider.dart';
import '../widgets/follow_button.dart';
import '../widgets/text_field_input.dart';

class ProfileScreen extends StatefulWidget {
  final String? profileUid;
  final snap;

  const ProfileScreen({super.key, this.profileUid, this.snap});

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
  late TextEditingController _bioController = TextEditingController();
  late TextEditingController _usernameController = TextEditingController();
  Uint8List? _image;
  bool _isLoading = false;
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
    final ModelProfile? profile = Provider.of<UserProvider>(context, listen: false).getProfile;
    _usernameController = TextEditingController(text: profile!.username);
    _bioController = TextEditingController(text: profile.bio);
  }

  @override
  void initState() {
    super.initState();
    final ModelProfile? profile = Provider.of<UserProvider>(context, listen: false).getProfile;

    //verifies if profile belongs to current profile or another profile
    userId = widget.profileUid ?? profile!.profileUid;
    getData();

    _usernameController = TextEditingController(text: profile!.username);
    _bioController = TextEditingController(text: profile.bio);
  }

  @override
  void dispose() {
    _bioController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  //GET DATA
  getData() async {
    final ModelProfile? profile = Provider.of<UserProvider>(context, listen: false).getProfile;
    setState(() {
      isLoading = true;
    });
    try {
      var userSnap = await FirebaseFirestore.instance.collectionGroup('profiles').where('profileUid', isEqualTo: userId).get();

      //GET POST LENGTH
      var postSnap = await FirebaseFirestore.instance.collection('posts').where('profileUid', isEqualTo: userId).get();

      postLen = postSnap.docs.length;
      userData = userSnap.docs.first.data();
      followers = userData['followers'].length;
      isFollowing = userData['followers'].contains(profile!.profileUid);

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
    final ModelProfile? profile = Provider.of<UserProvider>(context, listen: false).getProfile;
    setState(() {
      _isLoading = true;
    });
    String res = await FirestoreMethods().updateProfile(
      profileUid: profile!.profileUid,
      newUsername: _usernameController.text,
      newBio: _bioController.text,
      file: _image,
    );

    setState(() {
      _isLoading = false;
    });

    if (res != 'success') {
      if (!mounted) return;
      showSnackBar(res, context);
    } else {
      if (!mounted) return;
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final ModelProfile? profile = Provider.of<UserProvider>(context).getProfile;
    final ThemeData theme = Theme.of(context);

    return isLoading
        ? Center(
            child: CircularProgressIndicator(
              color: theme.colorScheme.secondary,
            ),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: theme.appBarTheme.backgroundColor,
              //APPBAR ROW
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(userData['username']),
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

                                        context.goNamed(AppRouter.savedPosts.name);
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
                                  userData['photoUrl'],
                                ),
                                radius: 40,
                              ),
                            ),
                            //USERNAME
                            Container(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.only(top: 10),
                              child: Text(
                                userData['username'],
                                style: const TextStyle(fontWeight: FontWeight.bold),
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
                            //PROFILE STATS ROW
                            profileStats(),
                            //SIGN OUT/FOLLOW BUTTON AND SETTINGS WHEEL
                            signOutButtonAndSettingsRow(profile, theme),
                          ],
                        ),
                      ),
                      const Divider(),
                      //PICTURES GRID
                      FutureBuilder(
                        future: FirebaseFirestore.instance.collection('posts').where('profileUid', isEqualTo: userId).orderBy('datePublished', descending: true).get(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(
                                color: theme.colorScheme.secondary,
                              ),
                            );
                          }
                          return GridView.builder(
                            shrinkWrap: true,
                            itemCount: (snapshot.data! as dynamic).docs.length,
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 5, mainAxisSpacing: 1.5, childAspectRatio: 1),
                            itemBuilder: (context, index) {
                              DocumentSnapshot snap = (snapshot.data! as dynamic).docs[index];

                              Widget mediaWidget;
                              final String contentType = getContentTypeFromUrl(snap['fileType']);
                              //return video
                              if (contentType == 'video') {
                                mediaWidget = ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: Image(
                                    image: NetworkImage(snap['videoThumbnail']),
                                    fit: BoxFit.cover,
                                  ),
                                );
                              } else {
                                // return image
                                mediaWidget = ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: Image(
                                    image: NetworkImage(snap['postUrl']),
                                    fit: BoxFit.cover,
                                  ),
                                );
                              }
                              return GestureDetector(
                                onTap: () {
                                  snap['profileUid'] == profile!.profileUid
                                      ? context.goNamed(
                                          AppRouter.openPostFromProfile.name,
                                          pathParameters: {
                                            'postId': snap['postId'],
                                            'profileUid': snap['profileUid'],
                                            'username': userData['username'],
                                          },
                                        )
                                      : context.goNamed(
                                          AppRouter.openPostFromFeed.name,
                                          pathParameters: {
                                            'postId': snap['postId'],
                                            'profileUid': snap['profileUid'],
                                            'username': userData['username'],
                                          },
                                        );
                                },
                                child: mediaWidget,
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
  }

  //PROFILE STATS ROW
  Widget profileStats() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        buildStatColumn(likes, "likes"),
        buildStatColumn(fish, "fish"),
        buildStatColumn(bones, "bones"),
        buildStatColumn(followers, "followers"),
      ],
    );
  }

  //SIGNOUT/FOLLOW BUTTON AND SETTINGS WHEEL
  Widget signOutButtonAndSettingsRow(ModelProfile? profile, ThemeData theme) {
    return Row(
      mainAxisAlignment: userData['profileUid'] == profile!.profileUid ? MainAxisAlignment.end : MainAxisAlignment.center,
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
                      await AuthMethods().signOut(context);
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
                          await FirestoreMethods().followUser(
                            profile.profileUid,
                            userData['profileUid'],
                          );
                          setState(() {
                            isFollowing = false;
                            followers--;
                          });
                        },
                      )
                    : FollowButton(
                        text: 'Follow',
                        backgroundColor: theme.colorScheme.secondary,
                        textColor: Colors.white,
                        borderColor: theme.colorScheme.secondary,
                        function: () async {
                          await FirestoreMethods().followUser(
                            profile.profileUid,
                            userData['profileUid'],
                          );
                          setState(
                            () {
                              isFollowing = true;
                              followers++;
                            },
                          );
                        },
                      ),
          ],
        ),
        if (userData['profileUid'] == profile.profileUid)
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
