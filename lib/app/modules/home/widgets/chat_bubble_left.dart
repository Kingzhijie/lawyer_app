import 'dart:math';

import 'package:flutter/material.dart';

import '../controllers/home_controller.dart';

class ChatBubbleLeft extends StatelessWidget {
  const ChatBubbleLeft({
    super.key,
    required this.message,
    required this.onAnimated,
    required this.onTick,
  });

  final UiMessage message;
  final VoidCallback onAnimated;
  final VoidCallback onTick;

  @override
  Widget build(BuildContext context) {
    final bubbleColor = Colors.grey.shade200;
    final textColor = Colors.black87;
    final radius = const BorderRadius.only(
      topLeft: Radius.circular(12),
      topRight: Radius.circular(12),
      bottomLeft: Radius.circular(2),
      bottomRight: Radius.circular(12),
    );

    final textWidget = _buildAnimatedText(textColor);

    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 6),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: bubbleColor,
              borderRadius: radius,
            ),
            child: textWidget,
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedText(Color textColor) {
    if (message.hasAnimated) {
      return Text(
        message.text,
        style: TextStyle(color: textColor, fontSize: 15),
      );
    }

    final total = message.text.length;
    final duration = Duration(milliseconds: max(600, 40 * total.clamp(1, 80)));

    return TweenAnimationBuilder<double>(
      key: ValueKey('tw-${message.id}'),
      tween: Tween(begin: 0, end: total.toDouble()),
      duration: duration,
      onEnd: onAnimated,
      builder: (context, value, _) {
        onTick();
        final count = value.clamp(0, total.toDouble()).floor();
        final text = message.text.substring(0, count);
        return Text(
          text.isEmpty ? ' ' : text,
          style: TextStyle(color: textColor, fontSize: 15),
        );
      },
    );
  }
}

