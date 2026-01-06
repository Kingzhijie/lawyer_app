import 'dart:math';
import 'package:flutter/material.dart';
import 'package:lawyer_app/app/common/constants/app_colors.dart';
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
  bool _showFinalAnswer = false;
  String _thinkingText = '';
  String? _previousThinkingProcess;

  @override
  void initState() {
    super.initState();
    _previousThinkingProcess = widget.message.thinkingProcess;
    _initDisplay();
  }

  @override
  void didUpdateWidget(ChatBubbleLeft oldWidget) {
    super.didUpdateWidget(oldWidget);
    // 检测思考内容是否有更新
    if (widget.message.thinkingProcess != _previousThinkingProcess) {
      _previousThinkingProcess = widget.message.thinkingProcess;
      // 实时更新思考内容
      if (widget.message.thinkingProcess != null) {
        setState(() {
          _showThinking = true;
          _thinkingText = widget.message.thinkingProcess!;
        });
      }
    }
    // 检测是否思考完成，显示最终答案
    if (widget.message.isThinkingDone && !_showFinalAnswer && widget.message.text.isNotEmpty) {
      setState(() {
        _showFinalAnswer = true;
      });
    }
  }

  void _initDisplay() {
    if (widget.message.hasAnimated) {
      // 已经动画过，直接显示所有内容
      _showThinking = widget.message.thinkingProcess != null;
      _showFinalAnswer = true;
      _thinkingText = widget.message.thinkingProcess ?? '';
    } else {
      // 未动画过
      if (widget.message.thinkingProcess != null) {
        // 有思考过程
        _showThinking = true;
        _thinkingText = widget.message.thinkingProcess!;
        if (widget.message.isThinkingDone && widget.message.text.isNotEmpty) {
          _showFinalAnswer = true;
        }
      } else {
        // 没有思考过程（如开场白），直接显示文本
        _showFinalAnswer = widget.message.text.isNotEmpty;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final textColor = Colors.black87;

    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 思考过程区域
          if (_showThinking && widget.message.thinkingProcess != null)
            Padding(
              padding: EdgeInsets.only(bottom: 8.toW, top: 10.toW),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 标题行：思考中... 或 思考完成(用时X秒)
                  Row(
                    children: [
                      Text(
                        widget.message.isThinkingDone
                            ? '思考完成${widget.message.thinkingSeconds != null ? "(用时${widget.message.thinkingSeconds}秒)" : ""}'
                            : '思考中...',
                        style: TextStyle(
                          fontSize: 14.toSp,
                          color: AppColors.color_E6000000,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      // 思考中显示加载动画
                      if (!widget.message.isThinkingDone) ...[
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
                  // 思考内容
                  if (_thinkingText.isNotEmpty) ...[
                    SizedBox(height: 12.toW),
                    Container(
                      padding: EdgeInsets.only(left: 12.toW),
                      decoration: BoxDecoration(
                        border: Border(left: BorderSide(color: AppColors.color_line, width: 0.5))
                      ),
                      child: Text(
                        _thinkingText,
                        style: TextStyle(
                          fontSize: 12.toSp,
                          color: AppColors.color_99000000,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          // 最终回复
          if (_showFinalAnswer && widget.message.text.isNotEmpty)
            Container(
              margin: EdgeInsets.symmetric(vertical: 14.toW),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildAnimatedText(textColor),
                  SizedBox(height: 14.toW),
                  if (!widget.message.isPrologue)
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
