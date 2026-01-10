import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lawyer_app/app/common/constants/app_colors.dart';
import 'package:lawyer_app/app/common/extension/widget_extension.dart';
import 'package:lawyer_app/app/utils/screen_utils.dart';
import 'package:lawyer_app/app/http/net/tool/logger.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../utils/image_utils.dart';
import '../../../../utils/toast_utils.dart';
import '../../models/ui_message.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';

class ChatBubbleLeft extends StatefulWidget {
  const ChatBubbleLeft({
    super.key,
    required this.message,
    required this.onAnimated,
    this.isLastAiMessage = false,
    this.onRefresh,
    this.updateCaseCallBack,
  });

  final UiMessage message;
  final VoidCallback onAnimated;
  final bool isLastAiMessage; // 是否是最后一条 AI 消息
  final VoidCallback? onRefresh; // 刷新回调
  final Function(bool isUpdate, int? caseId)? updateCaseCallBack;

  @override
  State<ChatBubbleLeft> createState() => _ChatBubbleLeftState();
}

class _ChatBubbleLeftState extends State<ChatBubbleLeft> {
  bool _showThinking = false;
  bool _showFinalAnswer = false;
  String _thinkingText = '';
  String? _previousThinkingProcess;
  String _previousText = '';

  @override
  void initState() {
    super.initState();
    _previousThinkingProcess = widget.message.thinkingProcess;
    _previousText = widget.message.text;
    _initDisplay();
  }

  @override
  void didUpdateWidget(ChatBubbleLeft oldWidget) {
    super.didUpdateWidget(oldWidget);

    bool needsUpdate = false;

    // 检测思考内容是否有更新（情况1：有思考过程）
    if (widget.message.thinkingProcess != _previousThinkingProcess) {
      _previousThinkingProcess = widget.message.thinkingProcess;
      if (widget.message.thinkingProcess != null &&
          widget.message.thinkingProcess!.isNotEmpty) {
        _showThinking = true;
        _thinkingText = widget.message.thinkingProcess!;
        needsUpdate = true;
        logPrint('🧠 思考内容更新: ${widget.message.thinkingProcess!.length} 字符');
      }
    }

    // 检测文本内容是否有更新（情况1和情况2都需要）
    if (widget.message.text != _previousText) {
      _previousText = widget.message.text;
      if (widget.message.text.isNotEmpty) {
        _showFinalAnswer = true;
        needsUpdate = true;
        logPrint('💬 文本内容更新: ${widget.message.text.length} 字符');
      }
    }

    // 检测是否思考完成（情况1：从思考中 -> 思考完成）
    if (widget.message.isThinkingDone && !oldWidget.message.isThinkingDone) {
      needsUpdate = true;
      logPrint('✅ 思考完成');
      // 思考完成后，如果有文本就显示
      if (widget.message.text.isNotEmpty) {
        _showFinalAnswer = true;
      }
    }

    // 只在需要时调用 setState
    if (needsUpdate) {
      setState(() {});
    }
  }

  void _initDisplay() {
    if (widget.message.hasAnimated) {
      // 已经动画过，直接显示所有内容
      _showThinking = widget.message.thinkingProcess != null;
      _showFinalAnswer = true;
      _thinkingText = widget.message.thinkingProcess ?? '';
    } else {
      // 未动画过 - 判断是哪种情况

      // 情况1：有思考过程（think: true）
      if (widget.message.thinkingProcess != null) {
        _showThinking = true;
        _thinkingText = widget.message.thinkingProcess!;
        // 只有在思考完成且有文本时才显示最终答案
        if (widget.message.isThinkingDone && widget.message.text.isNotEmpty) {
          _showFinalAnswer = true;
        }
      }
      // 情况2：没有思考过程，直接流式输出结果（think: false 或开场白）
      else {
        // 如果有文本内容，直接显示
        if (widget.message.text.isNotEmpty) {
          _showFinalAnswer = true;
        }
        // 如果文本为空且未完成，显示"思考中..."（通过 build 方法的最后一个判断）
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final textColor = Colors.black87;
    logPrint('caseId ======= ${widget.message.caseId}');
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
                        border: Border(
                          left: BorderSide(
                            color: AppColors.color_line,
                            width: 0.5,
                          ),
                        ),
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
                  // 只在最后一条 AI 消息且回复完成时显示操作按钮
                  if (!widget.message.isPrologue &&
                      widget.message.isThinkingDone &&
                      widget.isLastAiMessage)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildActionButton(Icons.refresh, () {
                          widget.onRefresh?.call();
                        }),
                        SizedBox(width: 12.toW),
                        _buildActionButton(Icons.copy, () {
                          final content = widget.message.text;
                          Clipboard.setData(ClipboardData(text: content));
                          showToast('复制成功');
                        }),
                      ],
                    ),
                  if (widget.message.caseId != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.message.caseId! > 0 ? '检测到系统中存在该案号相关信息' : '未检测到案号相关信息',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15.toSp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Height(6.toW),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.toW,
                            vertical: 4.toW,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.theme,
                            borderRadius: BorderRadius.circular(10.toW),
                          ),
                          child: Text(
                            '是否更新到案件中?',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.toSp,
                            ),
                          ),
                        ).withOnTap(() {
                          if (widget.updateCaseCallBack != null) {
                            widget.updateCaseCallBack!(
                              widget.message.caseId! > 0,
                              widget.message.caseId,
                            );
                          }
                        }),
                      ],
                    ).withMarginOnly(top: 15.toW),
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
                      valueColor: AlwaysStoppedAnimation(Colors.grey.shade600),
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
    // 如果已经动画过，或者是流式传输完成的消息，直接显示完整内容
    // 流式传输本身就是逐字显示，不需要再加打字动画
    if (widget.message.hasAnimated || widget.message.isThinkingDone) {
      return _setMarkDownWidget(widget.message.text, textColor);
    }

    // 只有非流式的消息（如历史消息）才使用打字动画
    final total = widget.message.text.length;
    final duration = Duration(milliseconds: max(600, 40 * total.clamp(1, 80)));

    return TweenAnimationBuilder<double>(
      key: ValueKey('tw-${widget.message.id}'),
      tween: Tween(begin: 0, end: total.toDouble()),
      duration: duration,
      onEnd: widget.onAnimated,
      builder: (context, value, _) {
        final count = value.clamp(0, total.toDouble()).floor();
        final text = widget.message.text.substring(0, count);
        return _setMarkDownWidget(text, textColor);
      },
    );
  }

  Widget _setMarkDownWidget(String text, Color textColor) {
    return MarkdownBody(
      data: text.isEmpty ? ' ' : text,
      selectable: true,
      // 支持文本选择
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
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          } else {}
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
        tableBorder: TableBorder.all(color: Colors.grey.shade300, width: 1),
        tableHead: TextStyle(fontWeight: FontWeight.bold, color: textColor),
        tableBody: TextStyle(color: textColor),
        tableCellsPadding: EdgeInsets.all(8.toW),
      ),
    );
  }
}
