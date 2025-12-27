import 'package:chat_bottom_container/chat_bottom_container.dart';
import 'package:flutter/material.dart';
import 'package:lawyer_app/app/common/constants/app_colors.dart';
import 'package:lawyer_app/app/modules/chatPage/controllers/chat_page_controller.dart';


class ChatBottomPanel extends StatelessWidget {
  const ChatBottomPanel({super.key, required this.controller});

  final ChatPageController controller;

  @override
  Widget build(BuildContext context) {
    return ChatBottomPanelContainer<ChatPanelType>(
      controller: controller.panelController,
      inputFocusNode: controller.inputFocusNode,
      panelBgColor: Colors.white.withOpacity(0.1),
      otherPanelWidget: (type) {
        switch (type) {
          case ChatPanelType.tool:
            return _ToolPanel();
          default:
            return const SizedBox.shrink();
        }
      },
      onPanelTypeChange: controller.onPanelTypeChange,
      // 默认切换，无额外动画
    );
  }
}

class _ToolPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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

