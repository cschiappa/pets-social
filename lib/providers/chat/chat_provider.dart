import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pets_social/models/profile.dart';
import 'package:pets_social/providers/auth/auth_provider.dart';
import 'package:pets_social/services/chat_methods.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'chat_provider.g.dart';

@Riverpod(keepAlive: true)
ChatService chatService(ChatServiceRef ref) {
  return ChatService();
}

@riverpod
Future<int> numberOfUnreadChats(NumberOfUnreadChatsRef ref, String profile) {
  final user = ref.watch(firebaseAuthProvider).currentUser;
  if (user == null) {
    throw AssertionError('User can\'t be null');
  }
  final repository = ref.watch(chatServiceProvider);
  return repository.numberOfUnreadChats(profile);
}

@riverpod
Future<List<DocumentSnapshot>> getChatsList(GetChatsListRef ref, ModelProfile? profile) {
  final repository = ref.watch(chatServiceProvider);
  return repository.getChatsList(profile);
}
