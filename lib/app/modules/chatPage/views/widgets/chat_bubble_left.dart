import 'dart:math';
import 'package:flutter/material.dart';
import 'package:lawyer_app/app/common/constants/app_colors.dart';
import 'package:lawyer_app/app/utils/screen_utils.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../utils/image_utils.dart';
import '../../controllers/chat_page_controller.dart';
import '../../models/ui_message.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';

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
          // 如果没有思考过程，也没有文本内容，但正在思考中，显示加载提示
          if (!widget.message.isThinkingDone && 
              widget.message.thinkingProcess == null && 
              widget.message.text.isEmpty)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 14.toW),
              child: Row(
                children: [
                  Text(
                    '思考中...',
                    style: TextStyle(
                      fontSize: 14.toSp,
                      color: AppColors.color_E6000000,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
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
        return _setMarkDownWidget(text, textColor);
      },
    );
  }

  Widget _setMarkDownWidget(String text, Color textColor) {
    return MarkdownBody(
      data: text.isEmpty ? ' ' : text,
      selectable: true, // 支持文本选择
      imageBuilder: (uri, title, alt) {
        // 自定义图片渲染，支持图文混排
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 8.toW),
          child: ImageUtils(
            imageUrl: uri.toString(),
            fit: BoxFit.cover,
            circularRadius: 8,
            placeholderColor: Colors.grey.shade200,
          ),
        );
      },
      onTapLink: (text, href, title) async {
        // 处理超链接点击
        if (href != null) {
          final uri = Uri.parse(href);
          if (await canLaunchUrl(uri)) {
            await launchUrl(
              uri,
              mode: LaunchMode.externalApplication,
            );
          } else {

          }
        }
      },
      styleSheet: MarkdownStyleSheet(
        p: TextStyle(color: textColor, fontSize: 15, height: 1.5),
        code: TextStyle(
          fontSize: 14,
          backgroundColor: Colors.grey.shade300,
          color: textColor,
        ),
        codeblockDecoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(8),
        ),
        codeblockPadding: EdgeInsets.all(12.toW),
        blockquote: TextStyle(
          fontSize: 15,
          color: Colors.black54,
          fontStyle: FontStyle.italic,
        ),
        blockquoteDecoration: BoxDecoration(
          color: Colors.grey.shade100,
          border: Border(
            left: BorderSide(color: Colors.grey.shade400, width: 4),
          ),
        ),
        blockquotePadding: EdgeInsets.all(10.toW),
        h1: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: textColor,
          height: 1.3,
        ),
        h2: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: textColor,
          height: 1.3,
        ),
        h3: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: textColor,
          height: 1.3,
        ),
        h1Padding: EdgeInsets.only(top: 16.toW, bottom: 8.toW),
        h2Padding: EdgeInsets.only(top: 14.toW, bottom: 6.toW),
        h3Padding: EdgeInsets.only(top: 12.toW, bottom: 4.toW),
        listBullet: TextStyle(fontSize: 15, color: textColor),
        listIndent: 24.toW,
        a: TextStyle(
          fontSize: 15,
          color: Colors.blue.shade700,
          decoration: TextDecoration.underline,
        ),
        em: TextStyle(fontStyle: FontStyle.italic),
        strong: TextStyle(fontWeight: FontWeight.bold),
        del: TextStyle(decoration: TextDecoration.lineThrough),
        tableBorder: TableBorder.all(
          color: Colors.grey.shade300,
          width: 1,
        ),
        tableHead: TextStyle(
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
        tableBody: TextStyle(color: textColor),
        tableCellsPadding: EdgeInsets.all(8.toW),
      ),
    );
  }


}
