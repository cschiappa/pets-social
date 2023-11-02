import 'package:cloud_firestore/cloud_firestore.dart';

class ModelNotification {
  final String? postId;
  final String body;
  final String receiver;
  final String sender;
  final DateTime datePublished;

  const ModelNotification({
    this.postId,
    required this.body,
    required this.receiver,
    required this.sender,
    required this.datePublished,
  });

  Map<String, dynamic> toJson() => {
        "postId": postId ?? "",
        "body": body,
        "receiver": receiver,
        "sender": sender,
        "datePublished": datePublished,
      };

  static ModelNotification fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return ModelNotification(
      postId: snapshot['postId'],
      body: snapshot['body'],
      receiver: snapshot['receiver'],
      sender: snapshot['sender'],
      datePublished: snapshot['datePublished'].toDate(),
    );
  }
}
