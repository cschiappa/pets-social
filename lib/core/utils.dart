import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:video_thumbnail/video_thumbnail.dart';

//Upload Image
pickImage(ImageSource source) async {
  final ImagePicker imagePicker = ImagePicker();

  XFile? file = await imagePicker.pickImage(source: source);

  if (file != null) {
    var filePath = file.path;
    final fileExtension = p.extension(filePath);
    final fileBytes = await file.readAsBytes();

    final thumbnail = fileBytes;
    return (fileBytes, fileExtension, thumbnail, filePath);
  }
  debugPrint('No image selected');
}

//Upload Video
pickVideo(ImageSource source) async {
  final ImagePicker videoPicker = ImagePicker();

  XFile? file = await videoPicker.pickVideo(source: source, maxDuration: const Duration(minutes: 10));

  if (file != null) {
    var filePath = file.path;
    final fileExtension = p.extension(filePath);
    final fileBytes = await file.readAsBytes();

    final thumbnail = await VideoThumbnail.thumbnailData(
      video: filePath,
      quality: 25,
      imageFormat: ImageFormat.JPEG,
    );

    return (fileBytes, fileExtension, thumbnail, filePath);
  }
  debugPrint('No video selected');
}

//PASSWORD CHECKER
bool isPasswordValid(String password) {
  const lengthRequirement = 5;
  final uppercaseRegex = RegExp(r'[A-Z]');
  final lowercaseRegex = RegExp(r'[a-z]');
  final numberRegex = RegExp(r'[0-9]');
  final specialCharacterRegex = RegExp(r'[!@#$%^&*()_+{}\[\]:;<>,.?~\\-]');

  if (password.length < lengthRequirement || !uppercaseRegex.hasMatch(password) || !lowercaseRegex.hasMatch(password) || !numberRegex.hasMatch(password) || !specialCharacterRegex.hasMatch(password)) {
    return false;
  }

  return true;
}

//Determine if file is an image or video
String getContentTypeFromUrl(fileType) {
  // Check if the URL ends with a known image file extension
  final imageExtensions = [
    '.jpg',
    '.jpeg',
    '.jpe',
    '.png',
    '.gif',
    '.bmp',
    '.webp',
    '.jfif ',
    '.svg',
  ];

  if (imageExtensions.contains(fileType)) {
    return 'image';
  }

  // Check if the URL ends with a known video file extension
  final videoExtensions = ['.mp4', '.avi', '.mov', '.mkv', '.webm', '.gif'];

  if (videoExtensions.contains(fileType)) {
    return 'video';
  }

  // If no match is found
  return 'unknown';
}

showSnackBar(String content, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(content),
    ),
  );
}
