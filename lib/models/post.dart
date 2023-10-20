import 'package:cloud_firestore/cloud_firestore.dart';

class ModelPost {
  final String uid;
  final String? description;
  final String profileUid;
  final String postId;
  final DateTime datePublished;
  final String postUrl;
  final List likes;
  final List bones;
  final List fish;
  final String fileType;
  final String videoThumbnail;

  ModelPost({
    required this.uid,
    this.description,
    required this.profileUid,
    required this.postId,
    required this.datePublished,
    required this.postUrl,
    required this.likes,
    required this.fish,
    required this.bones,
    required this.fileType,
    required this.videoThumbnail,
  });

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "description": description ?? "",
        "profileUid": profileUid,
        "postId": postId,
        "datePublished": datePublished,
        "postUrl": postUrl,
        "likes": likes,
        "fish": fish,
        "bones": bones,
        "fileType": fileType,
        "videoThumbnail": videoThumbnail,
      };

  static ModelPost fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return ModelPost(
        uid: snapshot['uid'],
        description: snapshot['description'],
        profileUid: snapshot['profileUid'],
        postId: snapshot['postId'],
        datePublished: snapshot['datePublished'].toDate(),
        postUrl: snapshot['postUrl'],
        likes: snapshot['likes'],
        fish: snapshot['fish'],
        bones: snapshot['bones'],
        fileType: snapshot['fileType'],
        videoThumbnail: snapshot['videoThumbnail']);
  }
}
