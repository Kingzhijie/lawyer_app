import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
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
import 'package:pull_to_refresh_new/pull_to_refresh.dart';
import 'package:record/record.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:uuid/uuid.dart';
import 'package:vibration/vibration.dart';

import '../../../http/net/sse_utils.dart';
import '../../../utils/image_picker_util.dart';
import '../models/chat_agent_ui_config.dart';
import '../models/chat_history_list.dart';
import '../models/ui_message.dart';

enum ChatPanelType { none, keyboard, tool }

class ChatPageController extends GetxController {
  final TextEditingController textController = TextEditingController();
  final FocusNode inputFocusNode = FocusNode();
  final ChatBottomPanelContainerController<ChatPanelType> panelController =
      ChatBottomPanelContainerController<ChatPanelType>();
  final ScrollController scrollController = ScrollController();

  /// 是否网络请求中
  bool isNetRequesting = false;

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
  var agentId = Rx<String?>(null);

  ///聊天id
  var sessionId = Rx<String?>(null);

  // 当前消息内容
  final RxString currentMessage = ''.obs;

  // 加载状态
  final RxBool isLoading = false.obs;

  RxList<MessageFileModel> files = <MessageFileModel>[].obs; // 文件数组
  RxList<MessageImageModel> images = <MessageImageModel>[].obs; // 图片数组

  // SSE 订阅
  StreamSubscription<SSEEvent>? _sseSubscription;

  // 语音识别是否可用（华为设备可能不支持）
  bool _isSpeechRecognitionAvailable = true;

  // 是否启用思考模式（默认启用）
  bool enableThinkingMode = true;

  ///是否显示未查询到案件
  RxBool isShowNoCase = false.obs;

  void updatePanelType(ChatPanelType type) {
    final targetPanelType = _toBottomPanel(type);
    final targetFocus = _toHandleFocus(type);

    _scrollToBottom();

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
        isPrologue: true,
        createdAt: DateTime.now(),
      ),
    );
  }

  ///添加发送消息
  Future<void> _addUserMessage(String text) async {
    isShowNoCase.value = false;
    logPrint('🚀 开始发送消息: $text');

    if (ObjectUtils.isEmptyString(agentId.value)) {
      logPrint('⚠️ agentId 为空');
      return;
    }
    if (ObjectUtils.isEmptyString(sessionId.value)) {
      logPrint('📝 创建会话 ID...');
      var result = await NetUtils.post(
        Apis.createChatId,
        params: {'agentId': agentId.value, 'subject': text},
        isLoading: false,
      );
      if (result.code == NetCodeHandle.success) {
        sessionId.value = result.data.toString();
        logPrint('✅ 会话 ID: $sessionId');
      }
    }

    if (!ObjectUtils.isEmptyString(sessionId.value)) {
      logPrint('📤 添加用户消息');
      messages.add(
        UiMessage(
          id: 'user-${DateTime.now().microsecondsSinceEpoch}',
          text: text,
          isAi: false,
          images: images.isNotEmpty
              ? images.map((img) => img.copyWith()).toList()
              : null,
          files: files.isNotEmpty
              ? files.map((file) => file.copyWith()).toList()
              : null,
          createdAt: DateTime.now(),
        ),
      );

      // 使用真实的 SSE 连接替代模拟回复
      logPrint('🔄 调用 _sendMessageWithSSE');
      _sendMessageWithSSE(text, sessionId.value!);
    }
  }

  /// 使用 SSE 发送消息并接收 AI 回复
  Future<void> _sendMessageWithSSE(String message, String sId) async {
    logPrint('🎯 _sendMessageWithSSE 开始执行');
    logPrint('📝 message: $message, sessionId: $sId');

    // 取消之前的连接
    cancelConnection();

    isLoading.value = true;
    currentMessage.value = '';

    // 用于累积思考过程和回复内容
    String thinkingContent = '';
    String replyContent = '';
    final startTime = DateTime.now();

    // 自动检测后端是否支持思考模式
    bool backendSupportsThinking = false;
    bool hasReceivedContent = false;

    // 创建一个临时的 AI 消息用于显示实时回复
    final aiMessageId = 'ai-${DateTime.now().microsecondsSinceEpoch}';

    // 立即添加一个 AI 消息占位（text 为空，聊天气泡会显示"思考中..."）
    messages.add(
      UiMessage(
        id: aiMessageId,
        text: '', // 空文本，让聊天气泡组件显示"思考中..."
        isAi: true,
        createdAt: DateTime.now(),
        isThinkingDone: false,
      ),
    );

    // 生成唯一的请求 ID
    final requestId = const Uuid().v4();

    List<SSEFileModel> uploadFiles = [];
    if (images.isNotEmpty) {
      for (var e in images) {
        uploadFiles.add(SSEFileModel(name: '', url: e.url ?? ''));
      }
    } else if (files.isNotEmpty) {
      for (var e in files) {
        uploadFiles.add(SSEFileModel(name: e.name ?? '', url: e.url ?? ''));
      }
    }

    // 清空图片和文件数组
    images.clear();
    files.clear();

    final request = SSEChatRequest(
      message: message,
      requestId: requestId,
      hisId: sId.toNullInt(),
      files: uploadFiles,
      think: enableThinkingMode, // 使用配置项
    );

    logPrint('发送消息: $message, 思考模式: $enableThinkingMode');

    try {
      _sseSubscription = await SSEUtils().chatStream(
        agentId: agentId.value!,
        request: request,
        onMessage: (data) {
          logPrint('📨 收到 SSE 事件 - eventType: ${data.eventType}');

          if (data.isOcrResult) {
            logPrint('caseId====${data.ocrCaseId}');
            isShowNoCase.value = true;
          }

          // 检测后端是否支持思考模式
          if (data.reasoningContent != null &&
              data.reasoningContent!.isNotEmpty) {
            backendSupportsThinking = true;
            thinkingContent += data.reasoningContent!;
            logPrint('✅ 收到思考内容: ${data.reasoningContent}');
            logPrint('📊 累积思考内容: $thinkingContent');
          }

          // 累积回复内容
          if (data.content != null && data.content!.isNotEmpty) {
            hasReceivedContent = true;
            replyContent += _sanitizeText(data.content!);
            logPrint('✅ 收到回复内容: ${data.content}');
            logPrint('📊 累积回复内容: $replyContent');
          }

          // 自动判断模式
          // 情况1：后端支持思考模式 - 有 reasoningContent
          // 情况2：后端不支持思考模式 - 只有 content，即使前端发送了 think: true
          final actualMode = backendSupportsThinking ? '思考模式' : '直接回复模式';

          // 移除"思考中"消息（只移除一次）
          messages.removeWhere((e) => e.id == 'think_id');

          // 创建更新的消息
          final aiMessage = UiMessage(
            id: aiMessageId,
            text: replyContent, // 回复内容，可能为空（思考阶段）或有内容（直接回复）
            isAi: true,
            createdAt: DateTime.now(),
            thinkingProcess: thinkingContent.isNotEmpty
                ? thinkingContent
                : null,
            isThinkingDone: false, // 流式传输中，未完成
          );

          // 查找是否已存在该消息
          final existingIndex = messages.indexWhere((m) => m.id == aiMessageId);
          if (existingIndex != -1) {
            // 更新现有消息 - 使用 replaceRange 确保触发响应式更新
            messages.replaceRange(existingIndex, existingIndex + 1, [
              aiMessage,
            ]);
            logPrint(
              '🔄 更新消息 [$actualMode] - 思考: ${thinkingContent.length} 字符, 回复: ${replyContent.length} 字符',
            );
          } else {
            // 添加新消息
            messages.add(aiMessage);
            logPrint(
              '➕ 添加新消息 [$actualMode] - 思考: ${thinkingContent.length} 字符, 回复: ${replyContent.length} 字符',
            );
          }
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
          final thinkingSeconds = DateTime.now()
              .difference(startTime)
              .inSeconds;

          final actualMode = backendSupportsThinking ? '思考模式' : '直接回复模式';

          logPrint('✅ 消息接收完成 [$actualMode]');
          logPrint(
            '📊 最终思考过程: $thinkingContent (${thinkingContent.length} 字符)',
          );
          logPrint('📊 最终回复内容: $replyContent (${replyContent.length} 字符)');
          logPrint('⏱️ 用时: $thinkingSeconds 秒');

          if (replyContent.isEmpty && thinkingContent.isEmpty) {
            logPrint('⚠️ 警告：没有收到任何内容！');
          }

          // 如果后端不支持思考模式但没有收到内容，可能是错误
          if (!backendSupportsThinking && !hasReceivedContent) {
            logPrint('⚠️ 后端可能不支持当前请求');
          }

          isLoading.value = false;

          // 移除"思考中"消息（确保清理）
          messages.removeWhere((e) => e.id == 'think_id');

          // 最终更新消息，包含完整的思考过程和用时
          final index = messages.indexWhere((m) => m.id == aiMessageId);
          if (index != -1) {
            final finalMessage = UiMessage(
              id: aiMessageId,
              text: replyContent.isNotEmpty ? replyContent : '未识别出相关案件',
              isAi: true,
              createdAt: messages[index].createdAt,
              hasAnimated: true, // 流式传输已经是逐字显示，不需要打字动画
              thinkingProcess: thinkingContent.isNotEmpty
                  ? thinkingContent
                  : null,
              thinkingSeconds: thinkingSeconds,
              isThinkingDone: true, // 流式传输完成
            );
            // 使用 replaceRange 确保触发响应式更新
            messages.replaceRange(index, index + 1, [finalMessage]);
            logPrint('🎯 最终消息已更新 [$actualMode]');
          } else {
            logPrint('⚠️ 未找到消息 ID: $aiMessageId');
          }
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

  void markMessageAnimated(String id) {
    final index = messages.indexWhere((m) => m.id == id);
    if (index == -1) return;
    final current = messages[index];
    if (current.hasAnimated) return;
    messages[index] = current.copyWith(hasAnimated: true);
  }

  // reverse: true 模式下，滚动到底部就是滚动到 position 0
  void _scrollToBottom({bool animated = true}) {
    if (!scrollController.hasClients) return;
    if (animated) {
      scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
      );
    } else {
      scrollController.jumpTo(0);
    }
  }

  @override
  void onInit() {
    super.onInit();
    textController.addListener(_handleTextChanged);
    _checkSpeechRecognitionAvailability();
    getSystemConfig();

    scrollController.addListener(_scrollListener);
  }

  ///滚动加载更多历史聊天记录
  void _scrollListener() {
    // 判断是否滚动到底部（阈值 50）
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 50) {
      if (isNetRequesting) {
        return;
      }
      getChatContent(sessionId.value, isLoadMore: true);
    }
  }

  /// 检查语音识别是否可用
  Future<void> _checkSpeechRecognitionAvailability() async {
    try {
      _isSpeechRecognitionAvailable = await _speechToText.initialize(
        onError: (error) {
          logPrint('语音识别初始化错误: ${error.errorMsg}');
          _isSpeechRecognitionAvailable = false;
        },
      );

      if (!_isSpeechRecognitionAvailable) {
        logPrint('⚠️ 语音识别不可用，录音功能已禁用');
      } else {
        logPrint('✅ 语音识别可用');
      }
    } catch (e) {
      _isSpeechRecognitionAvailable = false;
      logPrint('⚠️ 语音识别检测失败: $e');
    }
  }

  @override
  void onClose() {
    textController.removeListener(_handleTextChanged);
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
    // 检查语音识别是否可用
    if (!_isSpeechRecognitionAvailable) {
      showToast('当前设备不支持语音识别功能');
      return;
    }

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
    if (!_isSpeechRecognitionAvailable) {
      logPrint('⚠️ 语音识别不可用，跳过');
      return;
    }

    try {
      await _speechToText.listen(
        onResult: (result) {
          final text = _sanitizeText(result.recognizedWords);
          recognizedText.value = text;
          logPrint('语音识别: $text');
        },
        localeId: 'zh_CN',
      );
    } catch (e) {
      _isSpeechRecognitionAvailable = false;
      logPrint('⚠️ 启动语音识别失败: $e');
      showToast('语音识别启动失败');
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
        if (images.length >= 10) {
          showToast('最大上传10张图片');
          return;
        }
        var file = await ImagePickerUtil.takePhotoOrFromLibrary(
          imageSource: ImageSourceType.camera,
        );
        if (file != null) {
          uploadImage([file]);
        }
      case ActionType.photo:
        if (images.length >= 10) {
          showToast('最大上传10张图片');
          return;
        }
        var imgFiles = await ImagePickerUtil.takeManyPhotoOrFromLibrary(
          imageSource: ImageSourceType.gallery,
          maxCount: 10 - images.length,
        );
        uploadImage(imgFiles);
      case ActionType.file:
        // if (files.length >= 10) {
        //   showToast('最多上传10个文档');
        //   return;
        // }
        try {
          FilePickerResult? result = await FilePicker.platform.pickFiles(
            type: FileType.any, // 所有类型
            allowMultiple: true, // 允许多选
          );
          if (result != null && result.files.isNotEmpty) {
            for (var file in result.files) {
              // PlatformFile file = result.files.first;
              logPrint('文件名: ${file.name}');
              logPrint('文件大小: ${file.size} bytes');
              logPrint('文件路径: ${file.path}');
              logPrint('文件扩展名: ${file.extension}');
              if (file.path != null) {
                images.clear();
                files.add(
                  MessageFileModel(
                    path: file.path,
                    name: file.name,
                    type: file.extension,
                  ),
                );
                NetUtils.uploadSingleFile(file.path!).then((result) {
                  logPrint('result====$result');
                  if (result != null) {
                    // 找到对应的图片
                    final index = files.indexWhere((e) => e.path == file.path);
                    if (index != -1) {
                      // 使用 copyWith 更新 url
                      files[index] = files[index].copyWith(url: result);
                      files.refresh(); // 刷新 UI
                    }
                  }
                });
              }
            }
          }
        } catch (e) {
          logPrint('选取错误===$e');
        }
    }
  }

  ///上传图片
  void uploadImage(List<XFile>? imgFiles) {
    imgFiles?.forEach((file) {
      images.add(MessageImageModel(path: file.path));

      NetUtils.uploadSingleImage(file.path)
          .then((result) {
            if (result != null) {
              files.clear();
              // 找到对应的图片
              final index = images.indexWhere((e) => e.path == file.path);
              if (index != -1) {
                // 使用 copyWith 更新 url
                images[index] = images[index].copyWith(url: result);
                images.refresh(); // 刷新 UI
              }
            }
          })
          .catchError((error) {
            logPrint('上传图片失败: $error');
            // 可选：上传失败时移除该图片
            images.removeWhere((e) => e.path == file.path);
            images.refresh();
          });
    });
  }

  ///获取系统配置
  void getSystemConfig() {
    NetUtils.get(Apis.systemConfig).then((result) {
      if (result.code == NetCodeHandle.success) {
        var id = result.data?['sys_def_agent'];
        agentId.value = id.toString();
        _loadSessions(id);
      }
    });
  }

  ///获取Ai智能图UI配置
  void getAgentUIConfig(aId) {
    NetUtils.get(
      Apis.agentUIConfig,
      queryParameters: {'id': aId},
      isLoading: false,
    ).then((result) {
      if (result.code == NetCodeHandle.success) {
        var model = ChatAgentUiConfig.fromJson(result.data ?? {});
        _addAiWelcome(model);
      }
    });
  }

  ///获取最新的一条对话
  Future<void> _loadSessions(aId) async {
    NetUtils.get(
      Apis.getAiHistoryList,
      queryParameters: {'agentId': aId, 'pageNo': 1, 'pageSize': 1},
    ).then((result) {
      if (result.code == NetCodeHandle.success) {
        var list = (result.data['list'] as List)
            .map((e) => ChatHistoryList.fromJson(e))
            .toList();
        if (list.isNotEmpty) {
          var sId = list.first.id;
          getChatContent(sId);
        } else {
          getAgentUIConfig(aId);
        }
      }
    });
  }

  ///获取聊天内容
  void getChatContent(sId, {bool isLoadMore = false}) {
    sessionId.value = sId.toString();
    if (!isLoadMore) {
      messages.clear();
    }
    isNetRequesting = true;
    NetUtils.get(
      Apis.getAiChatContentList,
      queryParameters: {
        'hisId': sId,
        'cursor': messages.isEmpty ? sId : messages.first.id,
      },
      isLoading: false,
    ).then((result) {
      if (result.code == NetCodeHandle.success) {
        List datas = result.data as List;
        List<UiMessage> models = [];
        for (var map in datas) {
          var msg = map['message'].toString();
          if (!ObjectUtils.isEmptyString(msg)) {
            var msgMap = json.decode(msg);
            var content = msgMap['content'].toString();
            final finalMessage = UiMessage(
              id: map['id'].toString(),
              text: ObjectUtils.isEmptyString(content) ? '未查询到案件' : content,
              isAi: msgMap['role'] == 'assistant',
              createdAt: DateTime.fromMillisecondsSinceEpoch(
                msgMap['createTime'].toString().toInt(),
              ),
              hasAnimated: true, // 流式传输已经是逐字显示，不需要打字动画
              isThinkingDone: true, // 流式传输完成
            );
            models.add(finalMessage);
          }
        }
        if (isLoadMore) {
          messages.value.insertAll(0, models);
        } else {
          messages.value = models;
        }
        isNetRequesting = models.isEmpty;
        messages.refresh();
      } else {
        isNetRequesting = false;
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

  /// 刷新最后一条 AI 回复
  void refreshLastAiMessage() {
    logPrint('🔄 刷新最后一条 AI 回复');

    // 1. 找到最后一条 AI 消息
    final lastAiIndex = messages.lastIndexWhere((m) => m.isAi && !m.isPrologue);
    if (lastAiIndex == -1) {
      logPrint('⚠️ 没有找到 AI 消息');
      return;
    }

    // 2. 找到这条 AI 消息之前的最后一条用户消息
    final lastUserIndex = messages.lastIndexWhere(
      (m) => !m.isAi,
      lastAiIndex - 1,
    );

    if (lastUserIndex == -1) {
      logPrint('⚠️ 没有找到用户消息');
      return;
    }

    final lastUserMessage = messages[lastUserIndex];
    logPrint('📝 找到用户消息: ${lastUserMessage.text}');

    // 3. 移除最后一条 AI 消息
    messages.removeAt(lastAiIndex);
    logPrint('🗑️ 已移除 AI 消息');

    // 4. 重新发送用户消息
    final currentSessionId = sessionId.value;
    if (currentSessionId != null && currentSessionId.isNotEmpty) {
      logPrint('🔄 重新发送消息');
      _sendMessageWithSSE(lastUserMessage.text, currentSessionId);
    } else {
      logPrint('⚠️ sessionId 为空');
    }
  }

  ///新建对话
  void addNewChat() {}
  
}
