import 'package:flutter/material.dart';
import 'package:lawyer_app/app/common/constants/app_colors.dart';

import '../../controllers/chat_page_controller.dart';


class ChatBubbleRight extends StatelessWidget {
  const ChatBubbleRight({super.key, required this.message});

  final UiMessage message;

  @override
  Widget build(BuildContext context) {
    const bubbleColor = Colors.white;
    final textColor = AppColors.color_E6000000;
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
              boxShadow: [
                BoxShadow(
                  color: Color(0x0A000000),
                  blurRadius: 14,
                  offset: const Offset(0, 0),
                ),
              ]
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

