import 'package:flutter/material.dart';

import '../../controllers/chat_page_controller.dart';


class ChatBubbleRight extends StatelessWidget {
  const ChatBubbleRight({super.key, required this.message});

  final UiMessage message;

  @override
  Widget build(BuildContext context) {
    const bubbleColor = Color(0xFFE6F0FF);
    final textColor = Colors.blue.shade900;
    const radius = BorderRadius.only(
      topLeft: Radius.circular(12),
      topRight: Radius.circular(12),
      bottomLeft: Radius.circular(12),
      bottomRight: Radius.circular(2),
    );

    return Align(
      alignment: Alignment.centerRight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 6),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: bubbleColor,
              borderRadius: radius,
            ),
            child: Text(
              message.text,
              style: TextStyle(color: textColor, fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }
}

