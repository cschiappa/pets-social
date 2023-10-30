import "dart:typed_data";

import "package:firebase_auth/firebase_auth.dart";
import "package:firebase_storage/firebase_storage.dart";
import "package:uuid/uuid.dart";

class StorageMethods {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //add image to firebase storage
  Future<String> uploadImageToStorage(
      String childName, Uint8List file, bool isPost) async {
    Reference ref =
        _storage.ref().child(childName).child(_auth.currentUser!.uid);

    if (isPost) {
      String id = const Uuid().v1();
      ref = ref.child(id);
    }

    UploadTask uploadTask = ref.putData(file);

    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<void> uploadNotificationToStorage(String userUid, Map<String, dynamic> notificationData) async {
  await Firebase.initializeApp();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  try {
    await firestore.collection('notifications').doc(FirebaseAuth.instance.uid).add(notificationData);
    print('Notification data saved to Firestore for profile: $userUid');
  } catch (e) {
    print('Error saving notification data: $e');
  }
}
}
