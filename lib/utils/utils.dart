import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;

//Upload Image
pickImage(ImageSource source) async {
  final ImagePicker _imagePicker = ImagePicker();

  XFile? _file = await _imagePicker.pickImage(source: source);
  //if user doesnt pick an image
  if (_file != null) {
    var filePath = _file.path;
    final fileExtension = p.extension(filePath);
    final fileBytes = await _file.readAsBytes();
    return (fileBytes, fileExtension);
  }
  print('No image selected');
}

//Upload Video
pickVideo(ImageSource source) async {
  final ImagePicker _videoPicker = ImagePicker();

  XFile? _file = await _videoPicker.pickVideo(source: source);
  //if user doesnt pick an image
  if (_file != null) {
    var filePath = _file.path;
    final fileExtension = p.extension(filePath);
    final fileBytes = await _file.readAsBytes();
    return (fileBytes, fileExtension);
  }
  print('No video selected');
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
    '.webp'
  ];

  if (imageExtensions.contains(fileType)) {
    return 'image';
  }

  // Check if the URL ends with a known video file extension
  final videoExtensions = ['.mp4', '.avi', '.mov', '.mkv', '.webm'];

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
