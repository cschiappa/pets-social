import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String? description;
  final String uid;
  final String username;
  final String postId;
  final datePublished;
  final String postUrl;
  final String profImage;
  final likes;
  final bones;
  final fish;
  final fileType;

  Post({
    this.description,
    required this.uid,
    required this.username,
    required this.postId,
    required this.datePublished,
    required this.postUrl,
    required this.profImage,
    required this.likes,
    required this.fish,
    required this.bones,
    required this.fileType,
  });

  Map<String, dynamic> toJson() => {
        "description": description ?? "",
        "uid": uid,
        "username": username,
        "postId": postId,
        "datePublished": datePublished,
        "postUrl": postUrl,
        "profImage": profImage,
        "likes": likes,
        "fish": fish,
        "bones": bones,
        "fileType": fileType,
      };

  static Post fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Post(
        description: snapshot['description'],
        uid: snapshot['uid'],
        username: snapshot['username'],
        postId: snapshot['postId'],
        datePublished: snapshot['datePublished'],
        postUrl: snapshot['postUrl'],
        profImage: snapshot['profImage'],
        likes: snapshot['likes'],
        fish: snapshot['fish'],
        bones: snapshot['bones'],
        fileType: snapshot['fileType']);
  }
}
