import 'dart:async';
import 'dart:io';
import 'package:lawyer_app/app/utils/toast_utils.dart';
import 'package:path_provider/path_provider.dart';

import 'package:chat_bottom_container/chat_bottom_container.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lawyer_app/app/http/net/net_utils.dart';
import 'package:lawyer_app/app/http/net/tool/logger.dart';
import 'package:lawyer_app/app/utils/permission_util.dart';
import 'package:record/record.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

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
  final RxBool hasVoice = false.obs;
  final RxBool isRecording = false.obs; // 是否正在录音
  final RxBool isCancelMode = false.obs; // 是否处于取消模式（上移）
  final RxDouble recordingAmplitude = 0.0.obs; // 录音振幅，用于波形动画
  ChatPanelType currentPanelType = ChatPanelType.none;
  
  final AudioRecorder _audioRecorder = AudioRecorder();
  final stt.SpeechToText _speechToText = stt.SpeechToText();
  String? _recordingPath;
  Offset? _recordingStartPosition; // 记录开始录音时的位置
  String _recognizedText = ''; // 语音识别的文本结果
  StreamSubscription<Amplitude>? _amplitudeSubscription; // 振幅监听订阅，需要取消以避免内存泄露

  /// 统一切换面板逻辑：
  /// - keyboard：直接切换并请求焦点
  /// - tool：若当前有焦点先收起键盘，下一帧切换到 other，减少跳动
  /// - none：回到初始态
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

  /// 输入变化监听：用于更新 hasText，控制“发送/加号”切换
  void _handleTextChanged() {
    hasText.value = textController.text.trim().isNotEmpty;
  }

  /// 发送动作：添加用户消息，清空输入并保持焦点，然后模拟 AI 回复并滚动到底
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

  /// 点击输入框：无条件切到键盘，保证从其他面板回到可输入态
  void handleInputTap() {
    updatePanelType(ChatPanelType.keyboard);
  }

  /// PointerUp 兜底：当前未聚焦（可能只读/其他面板）时，切回键盘
  void handleInputPointerUp() {
    if (inputFocusNode.canRequestFocus && !inputFocusNode.hasFocus) {
      updatePanelType(ChatPanelType.keyboard);
    }
  }

  /// 点击加号：工具面板 <-> 键盘 间切换
  void handleToolBtnClick() {
    final isToolOpen = currentPanelType == ChatPanelType.tool;
    updatePanelType(isToolOpen ? ChatPanelType.keyboard : ChatPanelType.tool);
  }

  /// 同步当前面板状态（来自 ChatBottomPanelContainer 回调）
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

  /// 初始化时推送欢迎语，并滚动到底
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

  /// 添加用户消息并滚动到底
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

  /// 延迟 600ms 模拟 AI 回复，并滚动到底
  void _simulateAiReply(String userText) {
    Future.delayed(const Duration(milliseconds: 600), () {
      // 检查控制器是否已销毁，避免在销毁后执行操作
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

  /// 标记消息已完成打字动画，避免重复播放
  void markMessageAnimated(String id) {
    final index = messages.indexWhere((m) => m.id == id);
    if (index == -1) return;
    final current = messages[index];
    if (current.hasAnimated) return;
    messages[index] = current.copyWith(hasAnimated: true);
  }

  /// 滚动到底部；animated=false 使用 jump，animated=true 使用动画
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

  /// 带可选延时的滚动，常用于等待键盘高度稳定后再对齐底部
  void _scheduleScrollToBottom({bool animated = true, Duration delay = Duration.zero}) {
    final run = () {
      // 检查控制器是否已销毁
      if (isClosed) return;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // 再次检查，避免在回调执行时控制器已销毁
        if (!isClosed) {
          _scrollToBottom(animated: animated);
        }
      });
    };
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

  /// 打字动画过程中保持底部可见（使用 jump 避免多次动画抖动）
  void scheduleScrollDuringTyping() {
    if (isClosed) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!isClosed) {
        _scrollToBottom(animated: false);
      }
    });
  }

  /// 输入框高度变化时滚动到底，避免输入框长高后遮挡尾部消息
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
    // 移除监听器
    textController.removeListener(_handleTextChanged);
    inputFocusNode.removeListener(_handleFocusChange);
    
    // 停止并取消振幅监听订阅
    _stopAmplitudeListener();
    
    // 停止语音识别
    if (_speechToText.isListening) {
      _speechToText.stop();
    }
    
    // 如果正在录音，停止录音
    if (isRecording.value) {
      _audioRecorder.stop().catchError((e) {
        logPrint('停止录音失败: $e');
        return '';
      });
    }
    
    // 清理资源
    textController.dispose();
    inputFocusNode.dispose();
    scrollController.dispose();
    _audioRecorder.dispose();
    
    // 清理临时文件
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

  ///点击录音图标
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
      updatePanelType(hasVoice.value ? ChatPanelType.none : ChatPanelType.keyboard);
      if (!hasVoice.value) {
        inputFocusNode.requestFocus();
        _scheduleScrollToBottom();
      }
    }
  }

  /// 开始录音：检查权限后开始录音，并启动振幅监听和语音识别
  Future<void> startRecording(Offset startPosition) async {
    try {
      if (await _audioRecorder.hasPermission()) {
        final directory = await getTemporaryDirectory();
        _recordingPath = '${directory.path}/recording_${DateTime.now().millisecondsSinceEpoch}.m4a';
        
        await _audioRecorder.start(
          const RecordConfig(
            encoder: AudioEncoder.aacLc,
            bitRate: 128000,
            sampleRate: 44100,
          ),
          path: _recordingPath!,
        );
        
        _recordingStartPosition = startPosition;
        isRecording.value = true;
        isCancelMode.value = false;
        _recognizedText = ''; // 重置识别文本
        _startAmplitudeListener();
        _startSpeechRecognition();
      }
    } catch (e) {
      logPrint('开始录音失败: $e');
    }
  }

  /// 停止录音并发送：停止录音和语音识别，上传音频文件，将识别结果作为文字消息发送
  Future<void> stopRecording() async {
    if (!isRecording.value) return;
    
    try {
      final path = await _audioRecorder.stop();
      isRecording.value = false;
      _stopAmplitudeListener();
      await _stopSpeechRecognition();
      
      if (path != null && !isCancelMode.value) {
        // 如果有识别结果，发送识别文字；否则发送提示
        final textToSend = _recognizedText.trim();
        
        // 先发送消息，不等待上传
        if (textToSend.isNotEmpty) {
          _addUserMessage(textToSend);
          _simulateAiReply(textToSend);
          _scheduleScrollToBottom();
          // // 后台默默上传音频文件（不阻塞消息发送）
          // if (_recordingPath != null) {
          //   _uploadAudioFileInBackground(_recordingPath!);
          // }
        } else {
          showToast('未识别到任何内容');
          // 取消模式：直接删除文件
          final file = File(_recordingPath!);
          if (await file.exists()) {
            await file.delete();
          }
        }
      } else if (_recordingPath != null && isCancelMode.value) {
        // 取消模式：直接删除文件
        final file = File(_recordingPath!);
        if (await file.exists()) {
          await file.delete();
        }
      }
    } catch (e) {
      logPrint('停止录音失败: $e');
    }
    
    isCancelMode.value = false;
    _recognizedText = '';
  }

  /// 后台上传音频文件（不阻塞主流程）
  void _uploadAudioFileInBackground(String filePath) {
    // 异步上传，不等待结果
    Future(() async {
      try {
        final uploadResult = await NetUtils.uploadAudio(filePath);
        if (uploadResult != null) {
          logPrint('音频上传成功: ${uploadResult['audioUrl']}');
          // 上传成功后删除临时文件
          final file = File(filePath);
          if (await file.exists()) {
            await file.delete();
            logPrint('临时音频文件已删除: $filePath');
          }
        } else {
          logPrint('音频上传失败，保留文件: $filePath');
          // 上传失败时保留文件，可以后续重试
        }
      } catch (e) {
        logPrint('后台上传音频文件异常: $e');
        // 异常时保留文件
      }
    });
  }

  /// 取消录音：停止录音和语音识别，不发送消息
  Future<void> cancelRecording() async {
    if (!isRecording.value) return;
    
    try {
      await _audioRecorder.stop();
      isRecording.value = false;
      isCancelMode.value = false;
      _stopAmplitudeListener();
      await _stopSpeechRecognition();
      
      // 删除临时文件
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
    _recognizedText = '';
  }

  /// 检测手指位置，判断是否应该取消录音
  void checkCancelMode(Offset globalPosition) {
    if (!isRecording.value || _recordingStartPosition == null) return;
    
    // 如果手指上移超过 50px，进入取消模式
    final deltaY = _recordingStartPosition!.dy - globalPosition.dy;
    isCancelMode.value = deltaY > 50;
  }

  /// 开始监听录音振幅（用于波形动画）
  void _startAmplitudeListener() {
    // 先取消之前的订阅，避免重复订阅
    _amplitudeSubscription?.cancel();
    _amplitudeSubscription = _audioRecorder.onAmplitudeChanged(
      const Duration(milliseconds: 100),
    ).listen((amplitude) {
      // 检查控制器是否已销毁
      if (isClosed) return;
      // amplitude.dBFS 范围通常在 -160 到 0 之间
      // 转换为 0-1 范围用于动画
      final normalized = (amplitude.current + 160) / 160;
      recordingAmplitude.value = normalized.clamp(0.0, 1.0);
    });
  }

  /// 停止振幅监听：取消订阅以避免内存泄露
  void _stopAmplitudeListener() {
    _amplitudeSubscription?.cancel();
    _amplitudeSubscription = null;
    recordingAmplitude.value = 0.0;
  }

  /// 开始语音识别：在录音时同时进行实时语音识别
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
            if (result.finalResult) {
              // 最终结果
              _recognizedText = result.recognizedWords;
              logPrint('语音识别结果: $_recognizedText');
            } else {
              // 临时结果（实时更新）
              _recognizedText = result.recognizedWords;
            }
          },
          localeId: 'zh_CN', // 中文识别
          listenMode: stt.ListenMode.confirmation, // 确认模式
        );
      } else {
        logPrint('语音识别不可用');
      }
    } catch (e) {
      logPrint('启动语音识别失败: $e');
    }
  }

  /// 停止语音识别
  Future<void> _stopSpeechRecognition() async {
    try {
      if (_speechToText.isListening) {
        await _speechToText.stop();
      }
    } catch (e) {
      logPrint('停止语音识别失败: $e');
    }
  }

}
