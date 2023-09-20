import 'package:cloud_firestore/cloud_firestore.dart';

class ModelAccount {
  final String email;
  final String uid;

  const ModelAccount({
    required this.email,
    required this.uid,
  });

  Map<String, dynamic> toJson() => {
        "email": email,
        "uid": uid,
      };

  static ModelAccount fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return ModelAccount(
      email: snapshot['email'],
      uid: snapshot['uid'],
    );
  }
}
