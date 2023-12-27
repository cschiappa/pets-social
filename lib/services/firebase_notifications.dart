import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:pets_social/features/app_router.dart';
import 'package:pets_social/models/notification.dart';
import 'package:googleapis_auth/googleapis_auth.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  debugPrint('Title: ${message.notification?.title}');
  debugPrint('Body: ${message.notification?.body}');
  debugPrint('Payload: ${message.data}');
}

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  final _androidChannel = const AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This channel is used for important notifications',
    importance: Importance.max,
  );
  final _localNotifications = FlutterLocalNotificationsPlugin();

  void handleMessage(RemoteMessage? message) {
    if (message == null) return;

    // navigatorKey.currentState?.pushNamed(
    //   AppRouter.prizesScreen.name,
    //   arguments: message,
    // );
    router.goNamed(AppRouter.prizesScreen.name, extra: message);
  }

  //LOCAL NOTIFICATION
  Future initLocalNotifications() async {
    //const iOS = IOSInitializationSettings();
    const android = AndroidInitializationSettings('@drawable/ic_launcher');
    const settings = InitializationSettings(android: android);

    await _localNotifications.initialize(
      settings,
      onDidReceiveNotificationResponse: (details) async {
        final message = RemoteMessage.fromMap(jsonDecode(details.payload!));
        handleMessage(message);
      },
    );

    final platform = _localNotifications.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    await platform?.createNotificationChannel(_androidChannel);
  }

  //PUSH NOTIFICATION
  Future initPushNotifications() async {
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    FirebaseMessaging.onMessage.listen((message) {
      final notification = message.notification;
      if (notification == null) return;

      _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            _androidChannel.id,
            _androidChannel.name,
            channelDescription: _androidChannel.description,
            icon: '@drawable/ic_launcher',
          ),
        ),
        payload: jsonEncode(message.toMap()),
      );
    });
  }

  //INIT-NOTIFICATIONS GROUP
  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    final fCMToken = await _firebaseMessaging.getToken();
    debugPrint('Token: $fCMToken');
    initPushNotifications();
    initLocalNotifications();

    // Save the initial token to the database
    await saveTokenToDatabase(fCMToken!);

    // Any time the token refreshes, store this in the database too.
    FirebaseMessaging.instance.onTokenRefresh.listen(saveTokenToDatabase);
  }

  //SAVE TOKEN TO DATABASE
  Future<void> saveTokenToDatabase(String token) async {
    if (FirebaseAuth.instance.currentUser != null) {
      await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update({
        'tokens': FieldValue.arrayUnion([token]),
      });
    }
  }

  //REMOVE TOKEN FROM DATABASE
  Future<void> removeTokenFromDatabase() async {
    final token = await _firebaseMessaging.getToken();

    if (FirebaseAuth.instance.currentUser != null) {
      await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update({
        'tokens': FieldValue.arrayRemove([token]),
      });
    }
  }

// SEND NOTIFICATION
  Future<void> sendNotificationToUser(String userUid, String title, String body, String postId, String receiverUid, String senderUid) async {
    const String url = 'https://fcm.googleapis.com/v1/projects/pets-social-3d14e/messages:send';

    final user = await FirebaseFirestore.instance.collection('users').doc(userUid).get();

    final List<String> userFCMTokenList = List<String>.from(user['tokens']);

    var client = await obtainAuthenticatedClient();

    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${client.credentials.accessToken.data}',
    };

    try {
      uploadNotificationToStorage(postId, body, receiverUid, senderUid);
      for (String userFCMToken in userFCMTokenList) {
        final Map<String, dynamic> notificationData = {
          "message": {
            "token": userFCMToken,
            "notification": {
              "title": title,
              "body": body,
            },
          }
        };

        final response = await http.post(
          Uri.parse(url),
          headers: headers,
          body: json.encode(notificationData),
        );

        if (response.statusCode == 200) {
          debugPrint('Notification sent: ${response.body}');
        } else {
          debugPrint('Failed to send notification. Status code: ${response.statusCode}');
        }
      }
    } catch (e) {
      debugPrint('Error sending notification: $e');
    } finally {
      client.close();
    }
  }

//OBTAIN AUTHENTICATED CLIENT
  Future<AuthClient> obtainAuthenticatedClient() async {
    final accountCredentials = ServiceAccountCredentials.fromJson(
      utf8.decode(
        base64.decode(
          const String.fromEnvironment("SERVICE_ACCOUNT"),
        ),
      ),
    );
    var scopes = ['https://www.googleapis.com/auth/firebase.messaging'];

    AuthClient client = await clientViaServiceAccount(accountCredentials, scopes);

    return client;
  }

//NOTIFICATION METHOD FOR POSTS
  Future<void> notificationMethod(String postId, String profileUid, String action) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    //get user that made the post
    final user = await firestore.collection('posts').doc(postId).get().then((value) {
      return value.data()!['uid'];
    });

    //get profile that made the post
    final receiverUid = await firestore.collection('posts').doc(postId).get().then((value) {
      return value.data()!['profileUid'];
    });

    //get profile that liked the post
    final QuerySnapshot<Map<String, dynamic>> querySnapshot = await firestore.collectionGroup('profiles').where('profileUid', isEqualTo: profileUid).get();

    if (querySnapshot.docs.isNotEmpty) {
      final actionUser = querySnapshot.docs[0].data()['username'];

      await FirebaseApi().sendNotificationToUser(user, 'Pets Social', '$actionUser $action your post.', postId, receiverUid, profileUid);
    }
  }

//NOTIFICATION METHOD FOR FOLLOWING
  Future<void> followNotificationMethod(String followedProfile, String followingProfile) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final userProfile = await firestore.collectionGroup('profiles').where('profileUid', isEqualTo: followedProfile).get();

    if (userProfile.docs.isNotEmpty) {
      final user = userProfile.docs[0].reference.parent.parent!.id;

      //get profile that liked the post
      final QuerySnapshot<Map<String, dynamic>> querySnapshot = await firestore.collectionGroup('profiles').where('profileUid', isEqualTo: followingProfile).get();

      if (querySnapshot.docs.isNotEmpty) {
        final actionUser = querySnapshot.docs[0].data()['username'];

        await FirebaseApi().sendNotificationToUser(
          user,
          'Pets Social',
          '$actionUser started following you.',
          "",
          followedProfile,
          followingProfile,
        );
      }

      debugPrint('Parent Document ID: $user');
    } else {
      debugPrint('No matching documents found for the query.');
    }
  }

//UPLOAD NOTIFICATION TO STORAGE
  Future<void> uploadNotificationToStorage(String postId, String body, String receiverUid, String senderUid) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      String notificationId = const Uuid().v1();

      ModelNotification notification = ModelNotification(postId: postId, body: body, receiver: receiverUid, sender: senderUid, datePublished: DateTime.now());

      firestore.collection('notifications').doc(notificationId).set(notification.toJson());

      debugPrint('Notification added successfully!');
    } catch (e) {
      debugPrint('Error saving notification data: $e');
    }
  }

  //GET NOTIFICATION LIST
  Stream<List<DocumentSnapshot>> getNotifications(String profileUid) {
    final Query<Map<String, dynamic>> query = FirebaseFirestore.instance.collection('notifications').where('receiver', isEqualTo: profileUid).orderBy('datePublished', descending: true);

    return query.snapshots().map((querySnapshot) {
      return querySnapshot.docs;
    });
  }
}
