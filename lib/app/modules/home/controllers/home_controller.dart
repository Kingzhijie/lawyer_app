import 'package:chat_bottom_container/chat_bottom_container.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lawyer_app/app/http/net/tool/logger.dart';

class UiMessage {
  UiMessage({
    required this.id,
    required this.text,
    required this.isAi,
    required this.createdAt,
    this.hasAnimated = false,
  });

  final String id;
  final String text;
  final bool isAi;
  final DateTime createdAt;
  final bool hasAnimated;

  UiMessage copyWith({bool? hasAnimated}) => UiMessage(
        id: id,
        text: text,
        isAi: isAi,
        createdAt: createdAt,
        hasAnimated: hasAnimated ?? this.hasAnimated,
      );
}

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
  final ScrollController scrollController = ScrollController();

  final RxList<UiMessage> messages = <UiMessage>[].obs;
  final RxBool hasText = false.obs;
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

  /// 输入变化监听
  void _handleTextChanged() {
    hasText.value = textController.text.trim().isNotEmpty;
  }

  /// 发送按钮动作（模拟发送+AI回复）
  void handleSendPressed() {
    final text = textController.text.trim();
    if (text.isEmpty) return;
    _addUserMessage(text);
    textController.clear();
    hasText.value = false;
    inputFocusNode.requestFocus();
    _simulateAiReply(text);
    _scheduleScrollToBottom();
  }

  /// 点击输入框：切到键盘并请求焦点
  void handleInputTap() {
    logPrint('323232');
    updatePanelType(ChatPanelType.keyboard);
  }

  /// PointerUp：若当前是只读（可能处于其他面板），切回键盘
  void handleInputPointerUp() {
    if (inputFocusNode.canRequestFocus && !inputFocusNode.hasFocus) {
      updatePanelType(ChatPanelType.keyboard);
    }
  }

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

  void _addAiWelcome() {
    messages.add(
      UiMessage(
        id: 'welcome',
        text: '您好，我是 AI 助手，随时为您提供法律相关咨询。',
        isAi: true,
        createdAt: DateTime.now(),
      ),
    );
    _scheduleScrollToBottom(animated: false);
  }

  void _addUserMessage(String text) {
    messages.add(
      UiMessage(
        id: 'user-${DateTime.now().microsecondsSinceEpoch}',
        text: text,
        isAi: false,
        createdAt: DateTime.now(),
      ),
    );
    _scheduleScrollToBottom();
  }

  void _simulateAiReply(String userText) {
    Future.delayed(const Duration(milliseconds: 600), () {
      messages.add(
        UiMessage(
          id: 'ai-${DateTime.now().microsecondsSinceEpoch}',
          text: '这里是模拟的 AI 回复：$userText',
          isAi: true,
        createdAt: DateTime.now(),
        ),
      );
      _scheduleScrollToBottom();
    });
  }

  void markMessageAnimated(String id) {
    final index = messages.indexWhere((m) => m.id == id);
    if (index == -1) return;
    final current = messages[index];
    if (current.hasAnimated) return;
    messages[index] = current.copyWith(hasAnimated: true);
  }

  void _scrollToBottom({bool animated = true}) {
    if (!scrollController.hasClients) return;
    final position = scrollController.position.maxScrollExtent;
    if (animated) {
      scrollController.animateTo(
        position,
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
      );
    } else {
      scrollController.jumpTo(position);
    }
  }

  void _scheduleScrollToBottom({bool animated = true, Duration delay = Duration.zero}) {
    final run = () => WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollToBottom(animated: animated);
        });
    if (delay == Duration.zero) {
      run();
    } else {
      Future.delayed(delay, run);
    }
  }

  /// 打字动画过程中保持底部可见（使用 jump 避免多次动画抖动）
  void scheduleScrollDuringTyping() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom(animated: false);
    });
  }

  /// 输入框高度变化时也滚动到底，避免遮挡
  void handleInputSizeChanged(Size _) {
    _scheduleScrollToBottom(animated: false);
  }

  /// 键盘弹出时（获得焦点）向底部对齐，防止被遮挡
  void _handleFocusChange() {
    if (inputFocusNode.hasFocus) {
      _scheduleScrollToBottom(animated: false, delay: const Duration(milliseconds: 400));
    }
  }

  @override
  void onInit() {
    super.onInit();
    textController.addListener(_handleTextChanged);
    inputFocusNode.addListener(_handleFocusChange);
    _addAiWelcome();
  }

  @override
  void onClose() {
    textController.removeListener(_handleTextChanged);
    inputFocusNode.removeListener(_handleFocusChange);
    textController.dispose();
    inputFocusNode.dispose();
    scrollController.dispose();
    super.onClose();
  }
}
