import 'dart:async';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:lawyer_app/app/common/extension/string_extension.dart';
import 'package:lawyer_app/app/http/apis.dart';
import 'package:lawyer_app/app/http/net/net_utils.dart';
import 'package:lawyer_app/app/http/net/tool/error_handle.dart';
import 'package:lawyer_app/app/modules/chatPage/views/widgets/chat_bottom_panel.dart';
import 'package:lawyer_app/app/utils/object_utils.dart';
import 'package:path_provider/path_provider.dart';

import 'package:chat_bottom_container/chat_bottom_container.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lawyer_app/app/http/net/tool/logger.dart';
import 'package:lawyer_app/app/utils/permission_util.dart';
import 'package:lawyer_app/app/utils/toast_utils.dart';
import 'package:record/record.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:uuid/uuid.dart';
import 'package:vibration/vibration.dart';

import '../../../http/net/sse_utils.dart';
import '../../../utils/image_picker_util.dart';
import '../models/chat_agent_ui_config.dart';

class UiMessage {
  UiMessage({
    required this.id,
    required this.text,
    required this.isAi,
    required this.createdAt,
    this.hasAnimated = false,
    this.thinkingProcess,
    this.deepThinkingProcess,
    this.thinkingSeconds,
  });

  final String id;
  final String text;
  final bool isAi;
  final DateTime createdAt;
  final bool hasAnimated;
  final String? thinkingProcess; // 思考过程内容
  final String? deepThinkingProcess; // 深度思考过程内容
  final int? thinkingSeconds; // 思考用时

  UiMessage copyWith({
    bool? hasAnimated,
    String? thinkingProcess,
    String? deepThinkingProcess,
    int? thinkingSeconds,
  }) => UiMessage(
    id: id,
    text: text,
    isAi: isAi,
    createdAt: createdAt,
    hasAnimated: hasAnimated ?? this.hasAnimated,
    thinkingProcess: thinkingProcess ?? this.thinkingProcess,
    deepThinkingProcess: deepThinkingProcess ?? this.deepThinkingProcess,
    thinkingSeconds: thinkingSeconds ?? this.thinkingSeconds,
  );
}

enum ChatPanelType { none, keyboard, tool }

class ChatPageController extends GetxController {
  final TextEditingController textController = TextEditingController();
  final FocusNode inputFocusNode = FocusNode();
  final ChatBottomPanelContainerController<ChatPanelType> panelController =
      ChatBottomPanelContainerController<ChatPanelType>();
  final ScrollController scrollController = ScrollController();

  final RxList<UiMessage> messages = <UiMessage>[].obs;
  final RxBool hasText = false.obs;
  final RxBool hasVoice = false.obs;
  final RxBool isRecording = false.obs;
  final RxBool isCancelMode = false.obs;
  final RxDouble recordingAmplitude = 0.0.obs;
  final RxString recognizedText = ''.obs;
  ChatPanelType currentPanelType = ChatPanelType.none;

  final AudioRecorder _audioRecorder = AudioRecorder();
  final stt.SpeechToText _speechToText = stt.SpeechToText();
  String? _recordingPath;
  Offset? _recordingStartPosition;
  StreamSubscription<Amplitude>? _amplitudeSubscription;

  ///聊天智能体id
  String? agentId;
  ///聊天id
  String? sessionId;

  // 当前消息内容
  final RxString currentMessage = ''.obs;

  // 加载状态
  final RxBool isLoading = false.obs;

  // SSE 订阅
  StreamSubscription<SSEEvent>? _sseSubscription;

  void updatePanelType(ChatPanelType type) {
    final targetPanelType = _toBottomPanel(type);
    final targetFocus = _toHandleFocus(type);

    void update() {
      panelController.updatePanelType(
        targetPanelType,
        data: type,
        forceHandleFocus: targetFocus,
      );
    }

    final requiresUnfocusFirst =
        type == ChatPanelType.tool && inputFocusNode.hasFocus;
    if (requiresUnfocusFirst) {
      inputFocusNode.unfocus();
      WidgetsBinding.instance.addPostFrameCallback((_) => update());
    } else {
      update();
    }
  }

  void _handleTextChanged() {
    hasText.value = textController.text.trim().isNotEmpty;
  }

  void handleSendPressed({bool isFocus = true}) {
    final text = textController.text.trim();
    if (text.isEmpty) return;
    _addUserMessage(text);
    textController.clear();
    hasText.value = false;
    if (isFocus) {
      inputFocusNode.requestFocus();
    }
    // 已经在 _addUserMessage 中调用 SSE，不需要再调用 _simulateAiReply
    _scheduleScrollToBottom();
  }

  void handleInputTap() {
    updatePanelType(ChatPanelType.keyboard);
  }

  void handleInputPointerUp() {
    if (inputFocusNode.canRequestFocus && !inputFocusNode.hasFocus) {
      updatePanelType(ChatPanelType.keyboard);
    }
  }

  void handleToolBtnClick() {
    final isToolOpen = currentPanelType == ChatPanelType.tool;
    updatePanelType(isToolOpen ? ChatPanelType.keyboard : ChatPanelType.tool);
  }

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

  void hidePanel() {
    if (inputFocusNode.hasFocus) {
      inputFocusNode.unfocus();
    }
    if (panelController.currentPanelType != ChatBottomPanelType.none) {
      panelController.updatePanelType(ChatBottomPanelType.none);
    }
  }

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

  ChatBottomHandleFocus _toHandleFocus(ChatPanelType type) {
    switch (type) {
      case ChatPanelType.keyboard:
        return ChatBottomHandleFocus.requestFocus;
      case ChatPanelType.tool:
      case ChatPanelType.none:
        return ChatBottomHandleFocus.none;
    }
  }

  ///添加欢迎开场白
  void _addAiWelcome(ChatAgentUiConfig model) {
    messages.add(
      UiMessage(
        id: model.id.toString(),
        text: model.prologue ?? '您好，我是 AI 助手，随时为您提供法律相关咨询。',
        isAi: true,
        createdAt: DateTime.now(),
      ),
    );
    _scheduleScrollToBottom(animated: false);
  }


  ///添加发送消息
  Future<void> _addUserMessage(String text) async {
    if (ObjectUtils.isEmptyString(agentId)) {
      return;
    }
    if (ObjectUtils.isEmptyString(sessionId)) {
      var result = await NetUtils.post(
        Apis.createChatId,
        params: {'agentId': agentId, 'subject': text},
        isLoading: false,
      );
      if (result.code == NetCodeHandle.success) {
        sessionId = result.data.toString();
      }
    }

    if (!ObjectUtils.isEmptyString(sessionId)) {
      messages.add(
        UiMessage(
          id: 'user-${DateTime.now().microsecondsSinceEpoch}',
          text: text,
          isAi: false,
          createdAt: DateTime.now(),
        ),
      );

      _scheduleScrollToBottom();
      
      // 使用真实的 SSE 连接替代模拟回复
      _sendMessageWithSSE(text, sessionId!);
    }
  }

  /// 使用 SSE 发送消息并接收 AI 回复
  Future<void> _sendMessageWithSSE(String message, String sessionId) async {
    // 取消之前的连接
    cancelConnection();

    isLoading.value = true;
    currentMessage.value = '';
    
    // 用于累积思考过程和回复内容
    String thinkingContent = '';
    String replyContent = '';
    final startTime = DateTime.now();

    // 创建一个临时的 AI 消息用于显示实时回复
    final aiMessageId = 'ai-${DateTime.now().microsecondsSinceEpoch}';

    // 生成唯一的请求 ID
    final requestId = const Uuid().v4();

    final request = SSEChatRequest(
      message: message,
      requestId: requestId,
      hisId: sessionId.toNullInt(),
      think: true,
    );

    logPrint('发送消息: $message');

    try {
      _sseSubscription = await SSEUtils().chatStream(
        agentId: agentId!,
        request: request,
        onMessage: (data) {
          // 累积思考过程（reasoningContent）
          if (data.reasoningContent != null && data.reasoningContent!.isNotEmpty) {
            thinkingContent += data.reasoningContent!;
            logPrint('✅ 收到思考内容: ${data.reasoningContent}');
            logPrint('📊 累积思考内容: $thinkingContent');
          }
          
          // 累积回复内容（content）
          if (data.content != null && data.content!.isNotEmpty) {
            replyContent += data.content!;
            logPrint('✅ 收到回复内容: ${data.content}');
            logPrint('📊 累积回复内容: $replyContent');
          }

          // 移除"思考中"消息（只移除一次）
          messages.removeWhere((e) => e.id == 'think_id');

          // 创建更新的消息
          final aiMessage = UiMessage(
            id: aiMessageId,
            text: '',
            isAi: true,
            createdAt: DateTime.now(),
            thinkingProcess: thinkingContent.isNotEmpty ? thinkingContent : null,
            thinkingSeconds: 3
          );

          // 查找是否已存在该消息
          final existingIndex = messages.indexWhere((m) => m.id == aiMessageId);
          if (existingIndex != -1) {
            // 更新现有消息
            messages[existingIndex] = aiMessage;
            logPrint('🔄 更新消息 - 思考: ${thinkingContent.length} 字符, 回复: ${replyContent.length} 字符');
          } else {
            // 添加新消息
            messages.add(aiMessage);
            logPrint('➕ 添加新消息 - 思考: ${thinkingContent.length} 字符, 回复: ${replyContent.length} 字符');
          }
          
          // 触发滚动
          scheduleScrollDuringTyping();
        },
        onError: (error) {
          logPrint('SSE 错误: $error');
          showToast('连接失败: $error');
          isLoading.value = false;
          
          // 更新消息为错误状态
          final index = messages.indexWhere((m) => m.id == aiMessageId);
          if (index != -1) {
            messages[index] = UiMessage(
              id: aiMessageId,
              text: '抱歉，连接失败，请稍后重试。',
              isAi: true,
              createdAt: messages[index].createdAt,
            );
          }
        },
        onDone: () {
          // 计算思考用时（秒）
          final thinkingSeconds = DateTime.now().difference(startTime).inSeconds;
          
          logPrint('✅ 消息接收完成');
          logPrint('📊 最终思考过程: $thinkingContent (${thinkingContent.length} 字符)');
          logPrint('📊 最终回复内容: $replyContent (${replyContent.length} 字符)');
          logPrint('⏱️ 思考用时: $thinkingSeconds 秒');
          isLoading.value = false;
          
          // 移除"思考中"消息（确保清理）
          messages.removeWhere((e) => e.id == 'think_id');
          
          // 最终更新消息，包含完整的思考过程和用时
          final index = messages.indexWhere((m) => m.id == aiMessageId);
          if (index != -1) {
            messages[index] = UiMessage(
              id: aiMessageId,
              text: replyContent.isNotEmpty ? replyContent : '未收到回复内容',
              isAi: true,
              createdAt: messages[index].createdAt,
              hasAnimated: false, // 设置为 false 以触发打字动画
              thinkingProcess: thinkingContent.isNotEmpty ? thinkingContent : null,
              deepThinkingProcess: null, // 如果需要区分深度思考，可以根据实际情况设置
              thinkingSeconds: thinkingSeconds,
            );
            logPrint('🎯 最终消息已更新');
          } else {
            logPrint('⚠️ 未找到消息 ID: $aiMessageId');
          }
          
          _scheduleScrollToBottom();
        },
      );
    } catch (e) {
      logPrint('发送消息失败: $e');
      showToast('发送失败: $e');
      isLoading.value = false;
      
      // 更新消息为错误状态
      final index = messages.indexWhere((m) => m.id == aiMessageId);
      if (index != -1) {
        messages[index] = UiMessage(
          id: aiMessageId,
          text: '抱歉，发送失败，请稍后重试。',
          isAi: true,
          createdAt: messages[index].createdAt,
        );
      }
    }
  }

  /// 发送文本消息（已废弃，使用 _sendMessageWithSSE 替代）
  @Deprecated('使用 _sendMessageWithSSE 替代')
  Future<void> sendTextMessage(String message, String sessionId) async {
    // 此方法已被 _sendMessageWithSSE 替代
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

  void _scheduleScrollToBottom({
    bool animated = true,
    Duration delay = Duration.zero,
  }) {
    void run() {
      if (isClosed) return;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!isClosed) {
          _scrollToBottom(animated: animated);
        }
      });
    }

    if (delay == Duration.zero) {
      run();
    } else {
      Future.delayed(delay, () {
        if (!isClosed) {
          run();
        }
      });
    }
  }

  void scheduleScrollDuringTyping() {
    if (isClosed) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!isClosed) {
        _scrollToBottom(animated: false);
      }
    });
  }

  void handleInputSizeChanged(Size _) {
    _scheduleScrollToBottom(animated: false);
  }

  void _handleFocusChange() {
    if (inputFocusNode.hasFocus) {
      _scheduleScrollToBottom(
        animated: false,
        delay: const Duration(milliseconds: 400),
      );
    }
  }

  @override
  void onInit() {
    super.onInit();
    textController.addListener(_handleTextChanged);
    inputFocusNode.addListener(_handleFocusChange);
    getSystemConfig();
  }

  @override
  void onClose() {
    textController.removeListener(_handleTextChanged);
    inputFocusNode.removeListener(_handleFocusChange);
    _stopAmplitudeListener();
    if (_speechToText.isListening) {
      _speechToText.stop();
    }
    if (isRecording.value) {
      _audioRecorder.stop().catchError((e) {
        logPrint('停止录音失败: $e');
        return '';
      });
    }
    textController.dispose();
    inputFocusNode.dispose();
    scrollController.dispose();
    _audioRecorder.dispose();
    if (_recordingPath != null) {
      final file = File(_recordingPath!);
      file.exists().then((exists) {
        if (exists) {
          file.delete().catchError((e) {
            logPrint('删除临时文件失败: $e');
            return file;
          });
        }
      });
    }
    cancelConnection();
    super.onClose();
  }

  Future<void> handleVoicePressed() async {
    bool isAuth = false;
    if (Platform.isIOS) {
      bool isMicAuth = await PermissionUtils.requestMicrophonePermission();
      if (isMicAuth) {
        isAuth = await PermissionUtils.requestSpeechPermission();
      }
    } else {
      isAuth = await PermissionUtils.requestMicrophonePermission();
    }
    if (isAuth) {
      hasVoice.value = !hasVoice.value;
      updatePanelType(
        hasVoice.value ? ChatPanelType.none : ChatPanelType.keyboard,
      );
      if (!hasVoice.value) {
        inputFocusNode.requestFocus();
        _scheduleScrollToBottom();
      }
    }
  }

  Future<void> startRecording(Offset startPosition) async {
    // 防止重复触发
    if (isRecording.value) return;

    // 震动反馈 - 不使用 await，直接触发
    if (await Vibration.hasVibrator()) {
      Vibration.vibrate(duration: 50);
    }

    // 先显示录音 UI
    _recordingStartPosition = startPosition;
    isRecording.value = true;
    isCancelMode.value = false;
    recognizedText.value = '';

    try {
      if (await _audioRecorder.hasPermission()) {
        final directory = await getTemporaryDirectory();
        _recordingPath =
            '${directory.path}/recording_${DateTime.now().millisecondsSinceEpoch}.m4a';

        await _audioRecorder.start(
          const RecordConfig(
            encoder: AudioEncoder.aacLc,
            bitRate: 128000,
            sampleRate: 44100,
          ),
          path: _recordingPath!,
        );

        _startAmplitudeListener();
        _startSpeechRecognition();
      } else {
        isRecording.value = false;
      }
    } catch (e) {
      logPrint('开始录音失败: $e');
      isRecording.value = false;
    }
  }

  Future<void> stopRecording() async {
    if (!isRecording.value) return;

    try {
      final path = await _audioRecorder.stop();
      isRecording.value = false;
      _stopAmplitudeListener();
      await _stopSpeechRecognition();

      if (path != null && !isCancelMode.value) {
        final textToSend = recognizedText.value.trim();
        if (textToSend.isNotEmpty) {
          _addUserMessage(textToSend);
          // 已经在 _addUserMessage 中调用 SSE，不需要再调用 _simulateAiReply
          _scheduleScrollToBottom();
        } else {
          // showToast('未识别到任何内容');
          final file = File(_recordingPath!);
          if (await file.exists()) {
            await file.delete();
          }
        }
      } else if (_recordingPath != null && isCancelMode.value) {
        final file = File(_recordingPath!);
        if (await file.exists()) {
          await file.delete();
        }
      }
    } catch (e) {
      logPrint('停止录音失败: $e');
    }

    isCancelMode.value = false;
    recognizedText.value = '';
  }

  Future<void> cancelRecording() async {
    if (!isRecording.value) return;

    try {
      await _audioRecorder.stop();
      isRecording.value = false;
      isCancelMode.value = false;
      _stopAmplitudeListener();
      await _stopSpeechRecognition();

      if (_recordingPath != null) {
        final file = File(_recordingPath!);
        if (await file.exists()) {
          await file.delete();
        }
      }
    } catch (e) {
      logPrint('取消录音失败: $e');
    }

    _recordingStartPosition = null;
    recognizedText.value = '';
  }

  void checkCancelMode(Offset globalPosition) {
    if (!isRecording.value || _recordingStartPosition == null) return;
    final deltaY = _recordingStartPosition!.dy - globalPosition.dy;
    isCancelMode.value = deltaY > 50;
  }

  void _startAmplitudeListener() {
    _amplitudeSubscription?.cancel();
    _amplitudeSubscription = _audioRecorder
        .onAmplitudeChanged(const Duration(milliseconds: 100))
        .listen((amplitude) {
          if (isClosed) return;
          final normalized = (amplitude.current + 160) / 160;
          recordingAmplitude.value = normalized.clamp(0.0, 1.0);
        });
  }

  void _stopAmplitudeListener() {
    _amplitudeSubscription?.cancel();
    _amplitudeSubscription = null;
    recordingAmplitude.value = 0.0;
  }

  Future<void> _startSpeechRecognition() async {
    try {
      final available = await _speechToText.initialize(
        onError: (error) {
          logPrint('语音识别错误: ${error.errorMsg}');
        },
        onStatus: (status) {
          logPrint('语音识别状态: $status');
        },
      );

      if (available) {
        await _speechToText.listen(
          onResult: (result) {
            final text = _sanitizeText(result.recognizedWords);
            recognizedText.value = text;
            logPrint('语音识别: $text');
          },
          localeId: 'zh_CN',
        );
      } else {
        logPrint('语音识别不可用');
      }
    } catch (e) {
      logPrint('启动语音识别失败: $e');
    }
  }

  Future<void> _stopSpeechRecognition() async {
    try {
      if (_speechToText.isListening) {
        await _speechToText.stop();
      }
    } catch (e) {
      logPrint('停止语音识别失败: $e');
    }
  }

  String _sanitizeText(String text) {
    if (text.isEmpty) return text;
    final buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      final codeUnit = text.codeUnitAt(i);
      if (codeUnit >= 0xD800 && codeUnit <= 0xDFFF) {
        if (codeUnit <= 0xDBFF && i + 1 < text.length) {
          final nextCodeUnit = text.codeUnitAt(i + 1);
          if (nextCodeUnit >= 0xDC00 && nextCodeUnit <= 0xDFFF) {
            buffer.write(text[i]);
            buffer.write(text[i + 1]);
            i++;
            continue;
          }
        }
        continue;
      }
      if (codeUnit < 32 && codeUnit != 10 && codeUnit != 9) {
        continue;
      }
      buffer.write(text[i]);
    }
    return buffer.toString();
  }

  /// 点击功能区按钮
  Future<void> clickAction(ActionType type) async {
    switch (type) {
      case ActionType.camera:
        await ImagePickerUtil.takePhotoOrFromLibrary(
          imageSource: ImageSourceType.camera,
        );
      case ActionType.photo:
        await ImagePickerUtil.takePhotoOrFromLibrary(
          imageSource: ImageSourceType.gallery,
        );
      case ActionType.file:
        try {
          FilePickerResult? result = await FilePicker.platform.pickFiles(
            type: FileType.any, // 所有类型
            allowMultiple: false, // 单选
          );
          if (result != null && result.files.isNotEmpty) {
            PlatformFile file = result.files.first;
            logPrint('文件名: ${file.name}');
            logPrint('文件大小: ${file.size} bytes');
            logPrint('文件路径: ${file.path}');
            logPrint('文件扩展名: ${file.extension}');

            NetUtils.uploadSingleFile(file.path!).then((result) {
              logPrint('result====$result');
            });
          }
        } catch (e) {
          logPrint('选取错误===$e');
        }
    }
  }

  ///获取系统配置
  void getSystemConfig() {
    NetUtils.get(Apis.systemConfig).then((result) {
      if (result.code == NetCodeHandle.success) {
        var id = result.data?['sys_def_agent'];
        agentId = id.toString();
        getAgentUIConfig(id);
      }
    });
  }

  ///获取Ai智能图UI配置
  void getAgentUIConfig(id) {
    NetUtils.get(
      Apis.agentUIConfig,
      queryParameters: {'id': id},
      isLoading: false,
    ).then((result) {
      if (result.code == NetCodeHandle.success) {
        var model = ChatAgentUiConfig.fromJson(result.data ?? {});
        _addAiWelcome(model);
      }
    });
  }


  /// 取消当前连接
  void cancelConnection() {
    _sseSubscription?.cancel();
    _sseSubscription = null;
    isLoading.value = false;
    logPrint('SSE 连接已取消');
  }


}
