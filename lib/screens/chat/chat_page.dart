import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:pets_social/resources/chat_methods.dart';
import 'package:pets_social/widgets/chat_bubble.dart';
import 'package:pets_social/widgets/text_field_input.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../models/profile.dart';
import '../../providers/user_provider.dart';

class ChatPage extends StatefulWidget {
  final String receiverUserEmail;
  final String receiverUserID;
  final String receiverUsername;
  const ChatPage({super.key, required this.receiverUserEmail, required this.receiverUserID, required this.receiverUsername});

  @override
  ChatPageState createState() => ChatPageState();
}

class ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(widget.receiverUserID, widget.receiverUsername, _messageController.text, context);
      //clear text after sending
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
    final ModelProfile? profile = Provider.of<UserProvider>(context, listen: false).getProfile;
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
          children: snapshot.data!.docs.map((document) => _buildMessageItem(document)).toList(),
        );
      },
    );
  }

  Future<void> messageRead(Map<String, dynamic> data, String profile) async {
    if (!data['read'] && data['receiverUid'] == profile) {
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('chats').where('users', arrayContains: data['receiverUid']).where('users', arrayContains: data['senderUid']).get();

      print(querySnapshot);

      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        if (doc['lastMessage'] != null) {
          await doc.reference.update({
            'lastMessage': {
              ...doc['lastMessage'],
              'read': true,
            },
          });
        }
      }
    }
  }

  //build message item
  Widget _buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    final ModelProfile? profile = Provider.of<UserProvider>(context, listen: false).getProfile;
    final ThemeData theme = Theme.of(context);

    messageRead(data, profile!.profileUid);

    //align messages to right or left
    var alignment = (data['senderUid'] == profile.profileUid) ? Alignment.centerRight : Alignment.centerLeft;

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
