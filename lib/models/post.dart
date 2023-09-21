import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class ModelPost {
  final String? description;
  final String profileUid;
  final String username;
  final String postId;
  final datePublished;
  final String postUrl;
  final String profImage;
  final likes;
  final bones;
  final fish;
  final fileType;
  final String videoThumbnail;

  ModelPost({
    this.description,
    required this.profileUid,
    required this.username,
    required this.postId,
    required this.datePublished,
    required this.postUrl,
    required this.profImage,
    required this.likes,
    required this.fish,
    required this.bones,
    required this.fileType,
    required this.videoThumbnail,
  });

  Map<String, dynamic> toJson() => {
        "description": description ?? "",
        "profileUid": profileUid,
        "username": username,
        "postId": postId,
        "datePublished": datePublished,
        "postUrl": postUrl,
        "profImage": profImage,
        "likes": likes,
        "fish": fish,
        "bones": bones,
        "fileType": fileType,
        "videoThumbnail": videoThumbnail,
      };

  static ModelPost fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return ModelPost(
        description: snapshot['description'],
        profileUid: snapshot['profileUid'],
        username: snapshot['username'],
        postId: snapshot['postId'],
        datePublished: snapshot['datePublished'],
        postUrl: snapshot['postUrl'],
        profImage: snapshot['profImage'],
        likes: snapshot['likes'],
        fish: snapshot['fish'],
        bones: snapshot['bones'],
        fileType: snapshot['fileType'],
        videoThumbnail: snapshot['videoThumbnail']);
  }
}
