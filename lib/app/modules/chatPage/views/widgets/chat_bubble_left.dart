import 'dart:math';
import 'package:flutter/material.dart';
import 'package:lawyer_app/app/common/constants/app_colors.dart';
import 'package:lawyer_app/app/http/net/tool/logger.dart';
import 'package:lawyer_app/app/utils/screen_utils.dart';
import '../../controllers/chat_page_controller.dart';

class ChatBubbleLeft extends StatefulWidget {
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
  State<ChatBubbleLeft> createState() => _ChatBubbleLeftState();
}

class _ChatBubbleLeftState extends State<ChatBubbleLeft> {
  bool _showThinking = false;
  bool _showDeepThinking = false;
  bool _showFinalAnswer = false;
  String _thinkingText = '';
  String _deepThinkingText = '';

  @override
  void initState() {
    super.initState();
    if (!widget.message.hasAnimated) {
      _startAnimation();
    } else {
      // 已经动画过，直接显示所有内容
      _showThinking = widget.message.thinkingProcess != null;
      _showDeepThinking = widget.message.deepThinkingProcess != null;
      _showFinalAnswer = true;
      _thinkingText = widget.message.thinkingProcess ?? '';
      _deepThinkingText = widget.message.deepThinkingProcess ?? '';
    }
  }

  void _startAnimation() {
    // 先显示思考过程
    if (widget.message.thinkingProcess != null) {
      setState(() {
        _showThinking = true;
      });
      _animateThinkingText();
    } else {
      // 没有思考过程，直接显示答案
      setState(() {
        _showFinalAnswer = true;
      });
    }
  }

  void _animateThinkingText() {
    final text = widget.message.thinkingProcess!;
    int currentIndex = 0;

    void showNextChar() {
      if (currentIndex < text.length && mounted) {
        setState(() {
          _thinkingText = text.substring(0, currentIndex + 1);
        });
        // 在布局更新后触发滚动
        WidgetsBinding.instance.addPostFrameCallback((_) {
          widget.onTick();
        });
        currentIndex++;
        Future.delayed(const Duration(milliseconds: 30), showNextChar);
      } else if (mounted) {
        // 思考文字显示完成，开始深度思考
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted && widget.message.deepThinkingProcess != null) {
            setState(() {
              _showDeepThinking = true;
            });
            // 在布局更新后触发滚动
            WidgetsBinding.instance.addPostFrameCallback((_) {
              widget.onTick();
            });
            _animateDeepThinkingText();
          } else if (mounted) {
            // 没有深度思考，直接显示答案
            setState(() {
              _showFinalAnswer = true;
            });
            // 在布局更新后触发滚动
            WidgetsBinding.instance.addPostFrameCallback((_) {
              widget.onTick();
            });
          }
        });
      }
    }

    showNextChar();
  }

  void _animateDeepThinkingText() {
    final text = widget.message.deepThinkingProcess!;
    int currentIndex = 0;
    void showNextChar() {
      if (currentIndex < text.length && mounted) {
        setState(() {
          _deepThinkingText = text.substring(0, currentIndex + 1);
        });
        // 在布局更新后触发滚动
        WidgetsBinding.instance.addPostFrameCallback((_) {
          widget.onTick();
        });
        currentIndex++;
        Future.delayed(const Duration(milliseconds: 30), showNextChar);
      } else if (mounted) {
        // 深度思考文字显示完成，显示最终答案
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            setState(() {
              _showFinalAnswer = true;
            });
            // 在布局更新后触发滚动
            WidgetsBinding.instance.addPostFrameCallback((_) {
              widget.onTick();
            });
          }
        });
      }
    }

    showNextChar();
  }

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

    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 思考中...
          if (_showThinking && widget.message.thinkingProcess != null)
            Padding(
              padding: EdgeInsets.only(bottom: 8.toW, top: 10.toW),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        !_showDeepThinking ? '思考中...' : '已思考',
                        style: TextStyle(
                          fontSize: 14.toSp,
                          color: AppColors.color_E6000000,
                        ),
                      ),
                      if (!_showDeepThinking) ...[
                        SizedBox(width: 6.toW),
                        SizedBox(
                          width: 14.toW,
                          height: 14.toW,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation(
                              Colors.grey.shade600,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  if (_thinkingText.isNotEmpty) ...[
                    SizedBox(height: 8.toW),
                    Text(
                      _thinkingText,
                      style: TextStyle(
                        fontSize: 13.toSp,
                        color: AppColors.color_99000000,
                        height: 1.4,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          // 已深度思考
          if (_showDeepThinking && widget.message.deepThinkingProcess != null)
            Padding(
              padding: EdgeInsets.only(bottom: 8.toW, top: 8.toW),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '已思考${widget.message.thinkingSeconds != null ? "(用时${widget.message.thinkingSeconds}秒)" : ""}',
                    style: TextStyle(
                      fontSize: 14.toSp,
                      color: AppColors.color_E6000000,
                    ),
                  ),
                  if (_deepThinkingText.isNotEmpty) ...[
                    SizedBox(height: 8.toW),
                    Text(
                      _deepThinkingText,
                      style: TextStyle(
                        fontSize: 13.toSp,
                        color: AppColors.color_99000000,
                        height: 1.4,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          // 最终回复
          if (_showFinalAnswer)
            Container(
              margin: EdgeInsets.symmetric(vertical: 14.toW),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildAnimatedText(textColor),
                  SizedBox(height: 14.toW),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildActionButton(Icons.refresh, () {}),
                      SizedBox(width: 12.toW),
                      _buildActionButton(Icons.copy, () {}),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(6.toW),
        decoration: BoxDecoration(
          color: AppColors.color_FFF5F7FA,
          borderRadius: BorderRadius.circular(8.toW),
        ),
        child: Icon(icon, size: 16.toW, color: AppColors.color_E6000000),
      ),
    );
  }

  Widget _buildAnimatedText(Color textColor) {
    if (widget.message.hasAnimated) {
      return Text(
        widget.message.text,
        style: TextStyle(color: textColor, fontSize: 15, height: 1.5),
      );
    }

    final total = widget.message.text.length;
    final duration = Duration(milliseconds: max(600, 40 * total.clamp(1, 80)));

    return TweenAnimationBuilder<double>(
      key: ValueKey('tw-${widget.message.id}'),
      tween: Tween(begin: 0, end: total.toDouble()),
      duration: duration,
      onEnd: widget.onAnimated,
      builder: (context, value, _) {
        widget.onTick();
        final count = value.clamp(0, total.toDouble()).floor();
        final text = widget.message.text.substring(0, count);
        return Text(
          text.isEmpty ? ' ' : text,
          style: TextStyle(color: textColor, fontSize: 15, height: 1.5),
        );
      },
    );
  }
}
