import 'package:chat_bottom_container/chat_bottom_container.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum ChatPanelType {
  none,
  keyboard,
  tool,
}

class HomeController extends GetxController {
  final TextEditingController textController = TextEditingController();
  final FocusNode inputFocusNode = FocusNode();
  final ChatBottomPanelContainerController<ChatPanelType> panelController =
      ChatBottomPanelContainerController<ChatPanelType>();

  ChatPanelType currentPanelType = ChatPanelType.none;

  /// 统一切换面板逻辑，参考官方示例：切到工具时先收起键盘，下一帧切面板；切到键盘时请求焦点
  void updatePanelType(ChatPanelType type) {
    final targetPanelType = _toBottomPanel(type);
    final targetFocus = _toHandleFocus(type);

    void update() {
      panelController.updatePanelType(targetPanelType, data: type, forceHandleFocus: targetFocus);
    }

    final requiresUnfocusFirst = type == ChatPanelType.tool && inputFocusNode.hasFocus;
    if (requiresUnfocusFirst) {
      // 先收起键盘，再在下一帧切到功能面板，避免跳动
      inputFocusNode.unfocus();
      WidgetsBinding.instance.addPostFrameCallback((_) => update());
    } else {
      update();
    }
  }

  /// 点击输入框：切到键盘并请求焦点
  void handleInputTap() => updatePanelType(ChatPanelType.keyboard);

  /// 点击加号：在工具面板与键盘间切换
  void handleToolBtnClick() {
    final isToolOpen = currentPanelType == ChatPanelType.tool;
    updatePanelType(isToolOpen ? ChatPanelType.keyboard : ChatPanelType.tool);
  }

  /// 同步当前面板状态
  void onPanelTypeChange(ChatBottomPanelType panelType, ChatPanelType? data) {
    switch (panelType) {
      case ChatBottomPanelType.none:
        currentPanelType = ChatPanelType.none;
        break;
      case ChatBottomPanelType.keyboard:
        currentPanelType = ChatPanelType.keyboard;
        break;
      case ChatBottomPanelType.other:
        if (data == null) {
          currentPanelType = ChatPanelType.none;
          break;
        }
        currentPanelType = data;
        break;
    }
  }

  /// 点击空白处：收起键盘与面板
  void hidePanel() {
    if (inputFocusNode.hasFocus) {
      inputFocusNode.unfocus();
    }
    if (panelController.currentPanelType != ChatBottomPanelType.none) {
      panelController.updatePanelType(ChatBottomPanelType.none);
    }
  }

  /// 将自定义面板类型映射到底部容器类型
  ChatBottomPanelType _toBottomPanel(ChatPanelType type) {
    switch (type) {
      case ChatPanelType.none:
        return ChatBottomPanelType.none;
      case ChatPanelType.keyboard:
        return ChatBottomPanelType.keyboard;
      case ChatPanelType.tool:
        return ChatBottomPanelType.other;
    }
  }

  /// 不同面板对应的焦点处理
  ChatBottomHandleFocus _toHandleFocus(ChatPanelType type) {
    switch (type) {
      case ChatPanelType.keyboard:
        return ChatBottomHandleFocus.requestFocus;
      case ChatPanelType.tool:
      case ChatPanelType.none:
        return ChatBottomHandleFocus.none;
    }
  }

  @override
  void onClose() {
    textController.dispose();
    inputFocusNode.dispose();
    super.onClose();
  }
}
