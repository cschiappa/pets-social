import 'package:cloud_firestore/cloud_firestore.dart';

class ModelMessage {
  final String senderUid;
  final String receiverUid;
  final String message;
  final Timestamp timestamp;
  final String senderUsername;
  final String receiverUsername;
  final bool read;

  ModelMessage({
    required this.senderUid,
    required this.receiverUid,
    required this.timestamp,
    required this.message,
    required this.senderUsername,
    required this.receiverUsername,
    required this.read,
  });

  Map<String, dynamic> toJson() => {
        'senderUid': senderUid,
        'receiverUid': receiverUid,
        'message': message,
        'timestamp': timestamp,
        'senderUsername': senderUsername,
        'receiverUsername': receiverUsername,
        'read': read,
      };

  static ModelMessage fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return ModelMessage(
      senderUid: snapshot['senderUid'],
      receiverUid: snapshot['receiverUid'],
      timestamp: snapshot['timestamp'],
      message: snapshot['message'],
      senderUsername: snapshot['senderUsername'],
      receiverUsername: snapshot['receiverUsername'],
      read: snapshot['read'],
    );
  }
}
