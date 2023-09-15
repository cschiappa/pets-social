import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String email;
  final String uid;
  final String? photoUrl;
  final String username;
  final String? bio;
  final List followers;
  final List following;
  final List savedPost;
  final List blockedUsers;

  const User(
      {required this.email,
      required this.uid,
      this.photoUrl,
      required this.username,
      this.bio,
      required this.followers,
      required this.following,
      required this.savedPost,
      required this.blockedUsers});

  Map<String, dynamic> toJson() => {
        "username": username,
        "uid": uid,
        "email": email,
        "photoUrl": photoUrl ??
            'https://i.pinimg.com/474x/eb/bb/b4/ebbbb41de744b5ee43107b25bd27c753.jpg',
        "bio": bio ?? "",
        "followers": followers,
        "following": following,
        "savedPost": savedPost,
        "blockedUsers": blockedUsers
      };

  static User fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return User(
      username: snapshot['username'],
      uid: snapshot['uid'],
      email: snapshot['email'],
      photoUrl: snapshot['photoUrl'],
      bio: snapshot['bio'],
      followers: snapshot['followers'] ?? [],
      following: snapshot['following'] ?? [],
      savedPost: snapshot['savedPost'] ?? [],
      blockedUsers: snapshot['blockedUsers'] ?? [],
    );
  }
}
