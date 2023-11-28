import 'package:cloud_firestore/cloud_firestore.dart';

class ModelFeedback {
  final String summary;
  final String description;
  final DateTime datePublished;

  const ModelFeedback(
      {required this.summary,
      required this.description,
      required this.datePublished});

  Map<String, dynamic> toJson() => {
        "summary": summary,
        "description": description,
        "datePublished": datePublished,
      };

  static ModelFeedback fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return ModelFeedback(
        summary: snapshot['summary'],
        description: snapshot['description'],
        datePublished: snapshot['datePublished']);
  }
}
