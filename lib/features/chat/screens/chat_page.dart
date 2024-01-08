import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pets_social/features/chat/controller/chat_provider.dart';
import 'package:pets_social/features/profile/controller/profile_provider.dart';

import 'package:pets_social/features/chat/repository/chat_methods.dart';
import 'package:pets_social/core/widgets/chat_bubble.dart';
import 'package:pets_social/core/widgets/text_field_input.dart';
import 'package:pets_social/models/profile.dart';
import 'package:timeago/timeago.dart' as timeago;

class ChatPage extends ConsumerStatefulWidget {
  final String receiverUserEmail;
  final String receiverUserID;
  final String receiverUsername;
  const ChatPage({super.key, required this.receiverUserEmail, required this.receiverUserID, required this.receiverUsername});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => ChatPageState();
}

class ChatPageState extends ConsumerState<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ChatRepository _chatService = ChatRepository();

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      final ModelProfile? profile = ref.read(userProvider);
      await _chatService.sendMessage(widget.receiverUserID, widget.receiverUsername, _messageController.text, context, profile);
      _messageController.clear();
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        title: Text(widget.receiverUsername),
      ),
      body: Column(
        children: [
          //MESSAGES
          Expanded(
            child: _buildMessageList(),
          ),
          //USER INPUT
          _buildMessageInput(),
          const SizedBox(
            height: 25,
          )
        ],
      ),
    );
  }

  //BUILD MESSAGE LIST
  Widget _buildMessageList() {
    final ModelProfile? profile = ref.watch(userProvider);
    ref.watch(messageReadProvider(profile!.profileUid, widget.receiverUserID));
    final messages = ref.watch(getMessagesProvider(widget.receiverUserID, profile.profileUid));
    final ThemeData theme = Theme.of(context);

    return messages.when(
      error: (error, stackTrace) => Text('Error: $error'),
      loading: () => Center(
        child: CircularProgressIndicator(color: theme.colorScheme.secondary),
      ),
      data: (messages) {
        return ListView(
          reverse: true,
          children: messages.docs.map((message) => _buildMessageItem(message)).toList(),
        );
      },
    );
  }

  //build message item
  Widget _buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    final ModelProfile? profile = ref.read(userProvider);
    final ThemeData theme = Theme.of(context);

    //align messages to right or left
    var alignment = (data['senderUid'] == profile!.profileUid) ? Alignment.centerRight : Alignment.centerLeft;

    var color = (data['senderUid'] == profile.profileUid) ? theme.colorScheme.secondary : Colors.grey.shade700;

    final DateTime timeAgo = data['timestamp'].toDate();

    return Container(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(crossAxisAlignment: (data['senderUid'] == profile.profileUid) ? CrossAxisAlignment.end : CrossAxisAlignment.start, children: [
          ChatBubble(
            message: data['message'],
            color: color,
          ),
          Text(
            timeago.format(timeAgo).toString(),
            style: const TextStyle(fontSize: 10, color: Colors.white),
          ),
        ]),
      ),
    );
  }

  //build message input
  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Row(
        children: [
          Expanded(
            child: TextFieldInput(textEditingController: _messageController, labelText: 'Enter message', textInputType: TextInputType.text),
          ),
          IconButton(
              onPressed: sendMessage,
              icon: const Icon(
                Icons.reply,
                size: 40,
              ))
        ],
      ),
    );
  }
}
