import 'package:cloud_firestore/cloud_firestore.dart';

class ModelMessage {
  final String senderUid;
  final String senderEmail;
  final String receiverUid;
  final String message;
  final Timestamp timestamp;
  final String senderUsername;
  final String receiverUsername;

  ModelMessage({
    required this.senderUid,
    required this.senderEmail,
    required this.receiverUid,
    required this.timestamp,
    required this.message,
    required this.senderUsername,
    required this.receiverUsername,
  });

  //convert to a map
  Map<String, dynamic> toJson() => {
        'senderUid': senderUid,
        'senderEmal': senderEmail,
        'receiverUid': receiverUid,
        'message': message,
        'timestamp': timestamp,
        'senderUsername': senderUsername,
        'receiverUsername': receiverUsername,
      };

  static ModelMessage fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return ModelMessage(
        senderUid: snapshot['senderUid'],
        senderEmail: snapshot['senderEmail'],
        receiverUid: snapshot['receiverUid'],
        timestamp: snapshot['timestamp'],
        message: snapshot['message'],
        senderUsername: snapshot['senderUsername'],
        receiverUsername: snapshot['receiverUsername']);
  }
}
