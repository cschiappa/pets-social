import 'package:cloud_firestore/cloud_firestore.dart';

class ModelChatRoom {
  final List<String> users;
  final Map? lastMessage;

  const ModelChatRoom({
    required this.users,
    this.lastMessage,
  });

  Map<String, dynamic> toJson() => {
        "users": users,
        "lastMessage": lastMessage,
      };

  static ModelChatRoom fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return ModelChatRoom(
      users: snapshot['users'],
      lastMessage: snapshot['lastMessage'],
    );
  }
}
