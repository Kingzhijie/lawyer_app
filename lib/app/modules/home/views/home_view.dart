import 'dart:math';

import 'package:chat_bottom_container/chat_bottom_container.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI 对话'),
        centerTitle: true,
      ),
      resizeToAvoidBottomInset: false, // 官方推荐保持 false，由控件管理键盘/面板切换
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: controller.hidePanel,
        child: Column(
          children: [
            Expanded(
              child: Obx(
                () => ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                  controller: controller.scrollController,
                  itemCount: controller.messages.length,
                  itemBuilder: (context, index) {
                    final msg = controller.messages[index];
                    final isAi = msg.isAi;
                    final bubbleColor = isAi ? Colors.grey.shade200 : Colors.blue.shade50;
                    final align = isAi ? CrossAxisAlignment.start : CrossAxisAlignment.end;
                    final textColor = isAi ? Colors.black87 : Colors.blue.shade900;
                    final radius = BorderRadius.only(
                      topLeft: const Radius.circular(12),
                      topRight: const Radius.circular(12),
                      bottomLeft: isAi ? const Radius.circular(2) : const Radius.circular(12),
                      bottomRight: isAi ? const Radius.circular(12) : const Radius.circular(2),
                    );

                    Widget textWidget;
                    if (isAi && !msg.hasAnimated) {
                      final total = msg.text.length;
                      final duration =
                          Duration(milliseconds: max(600, 40 * total.clamp(1, 80)));
                      textWidget = TweenAnimationBuilder<double>(
                        key: ValueKey('tw-${msg.id}'),
                        tween: Tween(begin: 0, end: total.toDouble()),
                        duration: duration,
                        onEnd: () => controller.markMessageAnimated(msg.id),
                        builder: (context, value, _) {
                          controller.scheduleScrollDuringTyping();
                          final count = value.clamp(0, total.toDouble()).floor();
                          final text = msg.text.substring(0, count);
                          return Text(
                            text.isEmpty ? ' ' : text,
                            style: TextStyle(color: textColor, fontSize: 15),
                          );
                        },
                      );
                    } else {
                      textWidget = Text(
                        msg.text,
                        style: TextStyle(color: textColor, fontSize: 15),
                      );
                    }

                    return Align(
                      alignment: isAi ? Alignment.centerLeft : Alignment.centerRight,
                      child: Column(
                        crossAxisAlignment: align,
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
                  },
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              color: Colors.white,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Flexible(
                    child: Listener(
                      onPointerUp: (_) => controller.handleInputPointerUp(),
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return NotificationListener<SizeChangedLayoutNotification>(
                            onNotification: (_) {
                              controller.handleInputSizeChanged(Size.zero);
                              return false;
                            },
                            child: const SizeChangedLayoutNotifier(
                              child: _InputField(),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Obx(() {
                    final hasText = controller.hasText.value;
                    return IconButton(
                      icon: Icon(hasText ? Icons.send : Icons.add_circle_outline),
                      onPressed:
                          hasText ? controller.handleSendPressed : controller.handleToolBtnClick,
                      iconSize: 28,
                    );
                  }),
                ],
              ),
            ),
            ChatBottomPanelContainer<ChatPanelType>(
              controller: controller.panelController,
              inputFocusNode: controller.inputFocusNode,
              panelBgColor: Colors.grey.shade100,
              otherPanelWidget: (type) {
                switch (type) {
                  case ChatPanelType.tool:
                    return _buildToolPanel();
                  default:
                    return const SizedBox.shrink();
                }
              },
              onPanelTypeChange: controller.onPanelTypeChange,
              // 移除自定义动画，使用默认切换以保证顺畅
            ),
          ],
        ),
      )
    );
  }

  Widget _buildToolPanel() {
    return SizedBox(
      width: double.infinity,
      height: 300,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.extension, size: 36, color: Colors.grey),
          SizedBox(height: 12),
          Text(
            '功能面板占位区\n后续可在此添加自定义工具',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.black54),
          ),
        ],
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  const _InputField();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();
    return TextField(
      controller: controller.textController,
      focusNode: controller.inputFocusNode,
      minLines: 1,
      maxLines: 4, // 1-4 行内自适应，高度到 4 行后内部滚动
      keyboardType: TextInputType.multiline,
      decoration: InputDecoration(
        hintText: '请输入您要咨询的问题...',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.grey.shade100,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
      onSubmitted: (text){
        controller.handleSendPressed();
      },
      textInputAction: TextInputAction.send,
      onTap: controller.handleInputTap,
    );
  }
}
