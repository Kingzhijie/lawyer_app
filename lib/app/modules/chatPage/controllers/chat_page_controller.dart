import 'dart:async';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:lawyer_app/app/modules/chatPage/views/widgets/chat_bottom_panel.dart';
import 'package:path_provider/path_provider.dart';

import 'package:chat_bottom_container/chat_bottom_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lawyer_app/app/http/net/tool/logger.dart';
import 'package:lawyer_app/app/utils/permission_util.dart';
import 'package:lawyer_app/app/utils/toast_utils.dart';
import 'package:record/record.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:vibration/vibration.dart';

import '../../../utils/image_picker_util.dart';

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
      if (!isClosed) {
        messages.add(
          UiMessage(
            id: 'ai-${DateTime.now().microsecondsSinceEpoch}',
            text: '这里是模拟的 AI 回复：$userText',
            isAi: true,
            createdAt: DateTime.now(),
          ),
        );
        _scheduleScrollToBottom();
      }
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
    _addAiWelcome();
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
          _simulateAiReply(textToSend);
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
        var file = await ImagePickerUtil.takePhotoOrFromLibrary(
          imageSource: ImageSourceType.camera,
        );
      case ActionType.photo:
        var file = await ImagePickerUtil.takePhotoOrFromLibrary(
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
          }
        } catch(e) {
          logPrint('选取错误===$e');
        }

    }
  }

}
