import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pets_social/providers/user/user_provider.dart';
import 'package:pets_social/services/chat_methods.dart';
import 'package:pets_social/widgets/chat_bubble.dart';
import 'package:pets_social/widgets/text_field_input.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../models/profile.dart';

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
  final ChatService _chatService = ChatService();

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      final ModelProfile? profile = ref.read(userProvider);
      await _chatService.sendMessage(widget.receiverUserID, widget.receiverUsername, _messageController.text, context, profile);
      //clear text after sending
      _messageController.clear();
    }
  }

  @override
  void initState() {
    super.initState();
    messageRead();
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
          //messages
          Expanded(
            child: _buildMessageList(),
          ),
          //user input
          _buildMessageInput(),

          const SizedBox(
            height: 25,
          )
        ],
      ),
    );
  }

  //build message list
  Widget _buildMessageList() {
    final ModelProfile? profile = ref.read(userProvider);
    final ThemeData theme = Theme.of(context);

    return StreamBuilder(
      stream: _chatService.getMessages(widget.receiverUserID, profile!.profileUid), //THIS IS WRONG
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Error${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(color: theme.colorScheme.secondary),
          );
        }

        return ListView(
          reverse: true,
          children: snapshot.data!.docs.map((document) => _buildMessageItem(document)).toList(),
        );
      },
    );
  }

  Future<void> messageRead() async {
    final String profileUid = ref.watch(userProvider)!.profileUid;

    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('chats').where('lastMessage.receiverUid', isEqualTo: profileUid).where('lastMessage.senderUid', isEqualTo: widget.receiverUserID).where('lastMessage.read', isEqualTo: false).get();

    if (querySnapshot.docs.isNotEmpty) {
      await querySnapshot.docs.first.reference.update({
        'lastMessage': {
          ...querySnapshot.docs.first['lastMessage'],
          'read': true,
        },
      });
    }
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
          //textfield
          Expanded(
            child: TextFieldInput(textEditingController: _messageController, labelText: 'Enter message', textInputType: TextInputType.text),
          ),

          //send button
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
