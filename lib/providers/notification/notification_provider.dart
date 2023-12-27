import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pets_social/services/firebase_notifications.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notification_provider.g.dart';

//NOTIFICATIONMETHODS PROVIDER
@Riverpod(keepAlive: true)
FirebaseApi notificationsMethods(NotificationsMethodsRef ref) {
  return FirebaseApi();
}

//GET NOTIFICATIONS
@riverpod
Stream<List<DocumentSnapshot>> getNotifications(GetNotificationsRef ref, String profileUid) {
  final repository = ref.watch(notificationsMethodsProvider);
  return repository.getNotifications(profileUid);
}
