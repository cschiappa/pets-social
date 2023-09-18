import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderId;
  final String senderEmail;
  final String receiverId;
  final String message;
  final Timestamp timestamp;
  final String senderUsername;
  final String receiverUsername;

  Message({
    required this.senderId,
    required this.senderEmail,
    required this.receiverId,
    required this.timestamp,
    required this.message,
    required this.senderUsername,
    required this.receiverUsername,
  });

  //convert to a map
  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'senderEmal': senderEmail,
      'receiverId': receiverId,
      'message': message,
      'timestamp': timestamp,
      'senderUsername': senderUsername,
      'receiverUsername': receiverUsername,
    };
  }

  static Message fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Message(
        senderId: snapshot['senderId'],
        senderEmail: snapshot['senderEmail'],
        receiverId: snapshot['receiverId'],
        timestamp: snapshot['timestamp'],
        message: snapshot['message'],
        senderUsername: snapshot['senderUsername'],
        receiverUsername: snapshot['receiverUsername']);
  }
}
