import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:googleapis_auth/auth_io.dart';

import 'package:pets_social/main.dart';
import 'package:pets_social/resources/firestore_methods.dart';
import 'package:pets_social/screens/notifications_screen.dart';
import 'package:googleapis_auth/googleapis_auth.dart';

import 'package:http/http.dart' as http;

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

    navigatorKey.currentState?.pushNamed(
      NotificationScreen.route,
      arguments: message,
    );
  }

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

    final platform = _localNotifications.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await platform?.createNotificationChannel(_androidChannel);
  }

  Future initPushNotifications() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
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

  Future<void> saveTokenToDatabase(String token) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({
      'tokens': FieldValue.arrayUnion([token]),
    });
  }

// SEND NOTIFICATION
  Future<void> sendNotificationToUser(
      String userUid, String title, String body) async {
    const String url =
        'https://fcm.googleapis.com/v1/projects/pets-social-3d14e/messages:send';

    final user =
        await FirebaseFirestore.instance.collection('users').doc(userUid).get();

    final List<String> userFCMTokenList = List<String>.from(user['tokens']);

    var client = await obtainAuthenticatedClient();

    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${client.credentials.accessToken.data}',
    };

    try {
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
          debugPrint(
              'Failed to send notification. Status code: ${response.statusCode}');
        }
      }
    } catch (e) {
      debugPrint('Error sending notification: $e');
    } finally {
      client.close();
    }
  }

  Future<AuthClient> obtainAuthenticatedClient() async {
    final accountCredentials = ServiceAccountCredentials.fromJson(
      utf8.decode(
        base64.decode(
          const String.fromEnvironment("SERVICE_ACCOUNT"),
        ),
      ),
    );
    var scopes = ['https://www.googleapis.com/auth/firebase.messaging'];

    AuthClient client =
        await clientViaServiceAccount(accountCredentials, scopes);

    return client;
  }

  Future<void> notificationMethod(
      String postId, String profileUid, String action) async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    //get user that made the post
    final user =
        await _firestore.collection('posts').doc(postId).get().then((value) {
      return value.data()!['uid'];
    });

    //get profile that liked the post
    final QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
        .collectionGroup('profiles')
        .where('profileUid', isEqualTo: profileUid)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      final actionUser = querySnapshot.docs[0].data()['username'];

      await FirebaseApi().sendNotificationToUser(
          user, 'New notification', '$actionUser $action your post.');
    }
  }

  Future<void> followNotificationMethod(
      followedProfile, followingProfile) async {
    await FirebaseApi().sendNotificationToUser(followedProfile,
        'New notification', '$followingProfile started following you.');
  }
}
