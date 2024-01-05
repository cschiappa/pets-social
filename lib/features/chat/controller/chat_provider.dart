import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pets_social/models/profile.dart';
import 'package:pets_social/features/chat/repository/chat_methods.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_provider.g.dart';

@Riverpod(keepAlive: true)
ChatRepository chatRepository(ChatRepositoryRef ref) {
  return ChatRepository();
}

//NUMBER OF UNREAD MESSAGES
@riverpod
Stream<int> numberOfUnreadChats(NumberOfUnreadChatsRef ref, String profile) {
  final repository = ref.watch(chatRepositoryProvider);
  return repository.numberOfUnreadChats(profile);
}

//GET CHAT LIST
@riverpod
Future<List<DocumentSnapshot>> getChatsList(GetChatsListRef ref, ModelProfile? profile) {
  final repository = ref.watch(chatRepositoryProvider);
  return repository.getChatsList(profile);
}

//GET MESSAGES
@riverpod
Stream<QuerySnapshot> getMessages(GetMessagesRef ref, String userUid, String otherUserUid) {
  final repository = ref.watch(chatRepositoryProvider);
  return repository.getMessages(userUid, otherUserUid);
}

//UPDATE MESSAGE READ VALUE
@riverpod
Future<void> messageRead(MessageReadRef ref, String profileUid, String receiverUid) {
  final repository = ref.watch(chatRepositoryProvider);
  return repository.messageRead(profileUid, receiverUid);
}

//CHECK UNREAD MESSAGES
@riverpod
Stream<List<Map<String, dynamic>>> getLastMessage(GetLastMessageRef ref, String receiverUid, String senderUid) {
  final repository = ref.watch(chatRepositoryProvider);
  return repository.getLastMessage(receiverUid, senderUid);
}
