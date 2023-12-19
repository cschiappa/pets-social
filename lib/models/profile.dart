import 'package:cloud_firestore/cloud_firestore.dart';

class ModelProfile {
  final String email;
  final String profileUid;
  final String? photoUrl;
  final String username;
  final String? bio;
  final List followers;
  final List following;
  final List savedPost;
  final List blockedUsers;

  const ModelProfile({required this.email, required this.profileUid, this.photoUrl, required this.username, this.bio, required this.followers, required this.following, required this.savedPost, required this.blockedUsers});

  ModelProfile copyWith({
    String? email,
    String? profileUid,
    String? photoUrl,
    String? username,
    String? bio,
    List? followers,
    List? following,
    List? savedPost,
    List? blockedUsers,
  }) {
    return ModelProfile(
      email: email ?? this.email,
      profileUid: profileUid ?? this.profileUid,
      photoUrl: photoUrl ?? this.photoUrl,
      username: username ?? this.username,
      bio: bio ?? this.bio,
      followers: followers ?? this.followers,
      following: following ?? this.following,
      savedPost: savedPost ?? this.savedPost,
      blockedUsers: blockedUsers ?? this.blockedUsers,
    );
  }

  Map<String, dynamic> toJson() => {"username": username, "profileUid": profileUid, "email": email, "photoUrl": photoUrl ?? 'https://i.pinimg.com/474x/eb/bb/b4/ebbbb41de744b5ee43107b25bd27c753.jpg', "bio": bio ?? "", "followers": followers, "following": following, "savedPost": savedPost, "blockedUsers": blockedUsers};

  static ModelProfile fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return ModelProfile(
      username: snapshot['username'],
      profileUid: snapshot['profileUid'],
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
