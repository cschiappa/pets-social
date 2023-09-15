import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pets_social/models/user.dart';
import 'package:pets_social/providers/user_provider.dart';
import 'package:pets_social/resources/firestore_methods.dart';
import 'package:pets_social/screens/feed_screen.dart';
import 'package:pets_social/utils/colors.dart';
import 'package:pets_social/utils/utils.dart';
import 'package:pets_social/widgets/video_player.dart';
import 'package:provider/provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  Uint8List? _file;
  String? _fileType;
  final TextEditingController _descriptionController = TextEditingController();
  //loading when posting
  bool _isLoading = false;

  void postImage(
    String uid,
    String username,
    String profImage,
  ) async {
    setState(() {
      _isLoading = true;
    });
    try {
      String res = await FirestoreMethods().uploadPost(
          _descriptionController.text,
          _file!,
          uid,
          username,
          profImage,
          _fileType!);

      if (res == "success") {
        setState(() {
          _isLoading = false;
        });
        showSnackBar('Posted!', context);
        clearImage();
      } else {
        setState(() {
          _isLoading = false;
        });
        showSnackBar(res, context);
      }
    } catch (e) {
      showSnackBar(e.toString(), context);
    }
  }

  _selectImage(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text('Create a Post'),
            children: [
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Take a Photo'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file;
                  String fileType;
                  (file, fileType) = await pickImage(
                    ImageSource.camera,
                  );
                  setState(() {
                    _file = file;
                    _fileType = fileType;
                  });
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Take a Video'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file;
                  String fileType;
                  (file, fileType) = await pickVideo(
                    ImageSource.camera,
                  );
                  setState(() {
                    _file = file;
                    _fileType = fileType;
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
                  (file, fileType) = await pickImage(
                    ImageSource.gallery,
                  );
                  setState(() {
                    _file = file;
                    _fileType = fileType;
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
                  (file, fileType) = await pickVideo(
                    ImageSource.gallery,
                  );
                  setState(() {
                    _file = file;
                    _fileType = fileType;
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

//clear image after posting
  void clearImage() {
    setState(() {
      _file = null;
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const FeedScreen(),
        ),
      );
    });
  }

  @override
  void dispose() {
    super.dispose();
    _descriptionController.dispose();
  }

  Future<void> thumbnailMaker(videofile) async {
    final thumbnailVideo = await VideoThumbnail.thumbnailData(
      video: videofile.path,
      imageFormat: ImageFormat.JPEG,
      maxWidth: 128,
      quality: 25,
    );
  }

  @override
  Widget build(BuildContext context) {
    final User? user = Provider.of<UserProvider>(context).getUser;

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
              backgroundColor: mobileBackgroundColor,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: clearImage,
              ),
              title: const Text('Post to'),
              actions: [
                TextButton(
                    onPressed: () => postImage(
                        user!.uid, user.username, user.photoUrl ?? ""),
                    child: const Text('Post',
                        style: TextStyle(
                          color: pinkColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        )))
              ],
            ),
            body: Column(children: [
              _isLoading
                  ? const LinearProgressIndicator(
                      color: pinkColor,
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
                    backgroundImage: (user != null && user.photoUrl != null)
                        ? NetworkImage(user.photoUrl!)
                        : AssetImage('assets/default_pic')
                            as ImageProvider<Object>,
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
                          // : AspectRatio(
                          //     aspectRatio:
                          //         16 / 9, // Adjust the aspect ratio as needed
                          //     child: VideoPlayerWidget(videoUrl: videoUri),
                          //   ),
                          : Text('thumbnail')),
                  const Divider(),
                ],
              )
            ]),
          );
  }
}
