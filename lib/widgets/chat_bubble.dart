import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final Color color;

  const ChatBubble({
    super.key,
    required this.message,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 300, minWidth: 100),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              color: color.withOpacity(0.8),
            ),
            child: Text(
              message,
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
