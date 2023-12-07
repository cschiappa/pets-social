import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pets_social/features/app_router.dart';
import 'package:pets_social/models/profile.dart';
import 'package:pets_social/providers/user_provider.dart';
import 'package:pets_social/resources/firestore_methods.dart';
import 'package:pets_social/responsive/responsive_layout_screen.dart';
import 'package:pets_social/utils/utils.dart';
import 'package:provider/provider.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  Uint8List? _file;
  String? _fileType;
  Uint8List? _thumbnail;
  String? _filePath;
  final TextEditingController _descriptionController = TextEditingController();
  bool _isLoading = false;

  //POST IMAGE
  void postImage(
    String uid,
    String profileUid,
    String username,
    String profImage,
  ) async {
    setState(() {
      _isLoading = true;
    });
    try {
      String res = await FirestoreMethods().uploadPost(uid, _descriptionController.text, _file!, profileUid, username, profImage, _fileType!, _thumbnail!);

      if (res == "success") {
        setState(() {
          _isLoading = false;
        });
        if (!mounted) return;
        showSnackBar('Posted!', context);
        clearImage();
        context.goNamed(AppRouter.feedScreen.name);
      } else {
        setState(() {
          _isLoading = false;
        });
        if (!mounted) return;
        showSnackBar(res, context);
      }
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
  }

  //SELECT IMAGE
  _selectImage(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text('Create a Post'),
            children: [
              if (ResponsiveLayout.isMobile(context))
                SimpleDialogOption(
                  padding: const EdgeInsets.all(20),
                  child: const Text('Take a Photo'),
                  onPressed: () async {
                    Navigator.of(context).pop();
                    Uint8List file;
                    String fileType;
                    Uint8List thumbnail;
                    String filePath;
                    (file, fileType, thumbnail, filePath) = await pickImage(
                      ImageSource.camera,
                    );
                    setState(() {
                      _file = file;
                      _fileType = fileType;
                      _thumbnail = thumbnail;
                      _filePath = filePath;
                    });
                  },
                ),
              if (ResponsiveLayout.isMobile(context))
                SimpleDialogOption(
                  padding: const EdgeInsets.all(20),
                  child: const Text('Take a Video'),
                  onPressed: () async {
                    Navigator.of(context).pop();
                    Uint8List file;
                    String fileType;
                    Uint8List thumbnail;
                    String filePath;
                    (file, fileType, thumbnail, filePath) = await pickVideo(
                      ImageSource.camera,
                    );
                    setState(() {
                      _file = file;
                      _fileType = fileType;
                      _thumbnail = thumbnail;
                      _filePath = filePath;
                    });
                  },
                ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Choose Image from Gallery'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file;
                  String fileType;
                  Uint8List thumbnail;
                  String filePath;
                  (file, fileType, thumbnail, filePath) = await pickImage(
                    ImageSource.gallery,
                  );
                  setState(() {
                    _file = file;
                    _fileType = fileType;
                    _thumbnail = thumbnail;
                    _filePath = filePath;
                  });
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Choose Video from Gallery'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file;
                  String fileType;
                  Uint8List thumbnail;
                  String filePath;
                  (file, fileType, thumbnail, filePath) = await pickVideo(
                    ImageSource.gallery,
                  );
                  setState(() {
                    _file = file;
                    _fileType = fileType;
                    _thumbnail = thumbnail;
                    _filePath = filePath;
                  });
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

//CLEAR IMAGE AFTER POSTING
  void clearImage() {
    setState(() {
      _file = null;
    });
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ModelProfile? profile = Provider.of<UserProvider>(context).getProfile;
    final ThemeData theme = Theme.of(context);
    final firebaseauth = FirebaseAuth.instance.currentUser!.uid;

    return _file == null
        ? Center(
            child: IconButton(
              icon: const Icon(Icons.upload),
              iconSize: 50,
              onPressed: () => _selectImage(context),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: theme.appBarTheme.backgroundColor,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: clearImage,
              ),
              title: const Text('Post to'),
              actions: [
                TextButton(
                    onPressed: () => postImage(firebaseauth, profile!.profileUid, profile.username, profile.photoUrl ?? ""),
                    child: Text('Post',
                        style: TextStyle(
                          color: theme.colorScheme.secondary,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        )))
              ],
            ),
            body: Column(children: [
              _isLoading
                  ? LinearProgressIndicator(
                      color: theme.colorScheme.secondary,
                    )
                  : const Padding(
                      padding: EdgeInsets.only(top: 0),
                    ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundImage: (profile != null && profile.photoUrl != null) ? NetworkImage(profile.photoUrl!) : const AssetImage('assets/default_pic') as ImageProvider<Object>,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.45,
                    child: TextField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        hintText: "Write a caption...",
                        border: InputBorder.none,
                      ),
                      maxLines: 8,
                    ),
                  ),
                  SizedBox(
                      height: 45,
                      width: 45,
                      child: _file!.isEmpty || _file![0] == 255
                          ? AspectRatio(
                              aspectRatio: 487 / 451,
                              child: Container(
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                  image: MemoryImage(_file!),
                                  fit: BoxFit.fill,
                                  alignment: FractionalOffset.topCenter,
                                )),
                              ),
                            )
                          : AspectRatio(
                              aspectRatio: 487 / 451,
                              child: Container(
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                  image: MemoryImage(_thumbnail!),
                                  fit: BoxFit.fill,
                                  alignment: FractionalOffset.topCenter,
                                )),
                              ),
                            )),
                  const Divider(),
                ],
              )
            ]),
          );
  }
}
