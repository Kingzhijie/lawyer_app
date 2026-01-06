import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import '../../config/dio_config.dart';
import 'tool/logger.dart';

/// SSE 消息数据模型
class SSEMessageData {
  final String? content;
  final String? reasoningContent;
  final String? phase;
  final String? status;
  final String? role;
  final String? eventType; // 事件类型
  final Map<String, dynamic>? meta; // 文档元数据（用于 document 事件）
  final dynamic data; // 额外数据字段

  SSEMessageData({
    this.content,
    this.reasoningContent,
    this.phase,
    this.status,
    this.role,
    this.eventType,
    this.meta,
    this.data,
  });

  factory SSEMessageData.fromJson(
    Map<String, dynamic> json, {
    String? eventType,
  }) {
    String? content;
    Map<String, dynamic>? meta;
    dynamic data;

    // 处理 document 事件的特殊格式
    if (eventType == 'document') {
      content = json['content']?.toString();
      meta = json['meta'] as Map<String, dynamic>?;
      data = json['data'];
    } else {
      content = json['content']?.toString();
      data = json['data'];
    }

    return SSEMessageData(
      content: content,
      reasoningContent: json['reasoningContent']?.toString(),
      phase: json['phase']?.toString(),
      status: json['status']?.toString(),
      role: json['role']?.toString(),
      eventType: eventType,
      meta: meta,
      data: data,
    );
  }

  /// 是否是文档事件
  bool get isDocument => eventType == 'document';

  /// 是否是消息事件
  bool get isMessage => eventType == 'message';

  /// 获取文档 URL（仅用于 document 事件）
  String? get documentUrl => meta?['url']?.toString();

  /// 获取文档名称（仅用于 document 事件）
  String? get documentName => meta?['name']?.toString();
}

/// SSE 请求参数模型
class SSEChatRequest {
  final String? message;
  final List<SSEFileModel>? files;
  final String? audio;
  final String requestId;
  final int? hisId;
  final bool think;

  SSEChatRequest({
    this.message,
    this.files,
    this.audio,
    required this.requestId,
    this.hisId,
    this.think = true,
  }) : assert(message != null || audio != null, 'message 和 audio 必须至少提供一个');

  Map<String, dynamic> toJson() {
    return {
      if (message != null) 'message': message,
      if (files != null && files!.isNotEmpty)
        'files': files!.map((e) => e.toJson()).toList(),
      if (audio != null) 'audio': audio,
      'requestId': requestId,
      if (hisId != null) 'hisId': hisId,
      'think': think,
    };
  }
}

/// 文件模型
class SSEFileModel {
  final String url;
  final String name;

  SSEFileModel({required this.url, required this.name});

  Map<String, dynamic> toJson() {
    return {'url': url, 'name': name};
  }
}

/// SSE 事件类型
enum SSEEventType {
  message, // 普通消息
  error, // 错误
  done, // 完成
  unknown, // 未知类型
}

/// SSE 事件数据
class SSEEvent {
  final SSEEventType type;
  final String data;
  final String? error;

  SSEEvent({required this.type, required this.data, this.error});
}

/// SSE 工具类
class SSEUtils {
  static final SSEUtils _instance = SSEUtils._internal();
  factory SSEUtils() => _instance;
  SSEUtils._internal();

  /// 创建 SSE 连接并发送聊天请求
  ///
  /// [agentId] 智能体ID
  /// [request] 请求参数
  /// [onMessage] 消息回调 - 接收完整的消息数据
  /// [onError] 错误回调
  /// [onDone] 完成回调
  ///
  /// 返回一个 StreamSubscription，可用于取消订阅
  Future<StreamSubscription<SSEEvent>> chatStream({
    required String agentId,
    required SSEChatRequest request,
    required Function(SSEMessageData data) onMessage,
    Function(String error)? onError,
    Function()? onDone,
  }) async {
    try {
      // 创建一个新的 Dio 实例，避免日志拦截器干扰流式响应
      final dio = Dio(
        BaseOptions(
          baseUrl: DioConfig.baseURL,
          connectTimeout: DioConfig.connectTimeout,
          receiveTimeout: Duration(minutes: 5), // SSE 需要更长的超时时间
          sendTimeout: DioConfig.sendTimeout,
        ),
      );

      final url = '/ai/super-agent/chat/stream/$agentId';

      logPrint('SSE 请求 URL: ${DioConfig.baseURL}$url');
      logPrint('SSE 请求参数: ${jsonEncode(request.toJson())}');

      // 获取 token
      final token = 'test1';
      //StorageUtils.getToken();

      // 构建请求头
      final headers = {
        ...DioConfig.httpHeaders,
        if (token.isNotEmpty) 'Authorization': 'Bearer $token',
        'Accept': 'text/event-stream',
        'Cache-Control': 'no-cache',
        'Connection': 'keep-alive',
      };

      logPrint('SSE 请求 headers: $headers');

      final response = await dio.post<ResponseBody>(
        url,
        data: request.toJson(),
        options: Options(headers: headers, responseType: ResponseType.stream),
      );

      logPrint('SSE 连接已建立，开始接收数据...');

      final stream = response.data!.stream;
      final streamController = StreamController<SSEEvent>();

      String buffer = '';

      final subscription = stream.listen(
        (List<int> data) {
          // 将字节转换为字符串
          final text = utf8.decode(data);
          logPrint('SSE 收到原始数据: $text');
          buffer += text;

          // 按双换行符分割 SSE 事件
          final events = buffer.split('\n\n');
          // 保留最后一个不完整的事件
          buffer = events.last;

          for (var i = 0; i < events.length - 1; i++) {
            final eventText = events[i].trim();
            if (eventText.isEmpty) continue;

            logPrint('SSE 解析事件: $eventText');

            // 解析 SSE 事件
            final lines = eventText.split('\n');
            String? eventData;
            String? eventType;

            for (var line in lines) {
              if (line.startsWith('event:')) {
                eventType = line.substring(6).trim();
              } else if (line.startsWith('data:')) {
                eventData = line.substring(5).trim();
              } else if (line.startsWith('data: ')) {
                eventData = line.substring(6).trim();
              }
            }

            // 注意：不再跳过 tools 事件，让它正常处理

            if (eventData != null && eventData.isNotEmpty) {
              logPrint('SSE 提取数据: $eventData');

              // 跳过空数组 []
              if (eventData.trim() == '[]') {
                logPrint('⏭️ 跳过空数组');
                continue;
              }

              // 检查是否是结束标记
              if (eventData == '[DONE]') {
                final event = SSEEvent(
                  type: SSEEventType.done,
                  data: eventData,
                );
                streamController.add(event);
                if (onDone != null) {
                  onDone();
                }
              } else {
                // 尝试解析 JSON
                try {
                  final json = jsonDecode(eventData);

                  // 检查是否有错误
                  if (json is Map && json.containsKey('error')) {
                    final event = SSEEvent(
                      type: SSEEventType.error,
                      data: eventData,
                      error: json['error'].toString(),
                    );
                    streamController.add(event);
                    if (onError != null) {
                      onError(json['error'].toString());
                    }
                  } else if (json is List && json.isNotEmpty) {
                    // 处理数组格式（如 document 事件）
                    for (var item in json) {
                      if (item is Map) {
                        final messageData = SSEMessageData.fromJson(
                          Map<String, dynamic>.from(item),
                          eventType: eventType,
                        );

                        logPrint(
                          '📄 解析数组项 - eventType: $eventType, content 长度: ${messageData.content?.length ?? 0}',
                        );

                        // document 事件总是处理，即使内容很长
                        if (eventType == 'document' ||
                            (messageData.content != null &&
                                messageData.content!.isNotEmpty) ||
                            (messageData.reasoningContent != null &&
                                messageData.reasoningContent!.isNotEmpty)) {
                          final event = SSEEvent(
                            type: SSEEventType.message,
                            data: jsonEncode(item),
                          );
                          streamController.add(event);
                          onMessage(messageData);
                        }
                      }
                    }
                  } else if (json is Map) {
                    // 解析消息数据，传递事件类型
                    final messageData = SSEMessageData.fromJson(
                      Map<String, dynamic>.from(json),
                      eventType: eventType,
                    );

                    logPrint(
                      '解析后的数据 - eventType: $eventType, content: ${messageData.content}, reasoningContent: ${messageData.reasoningContent}',
                    );

                    // 检查是否有实际内容（content 或 reasoningContent）
                    final hasContent =
                        (messageData.content != null &&
                            messageData.content!.isNotEmpty) ||
                        (messageData.reasoningContent != null &&
                            messageData.reasoningContent!.isNotEmpty);

                    // tools、tools-res、ocr_file_type、document 等事件即使没有 content 也要处理
                    final isSpecialEvent =
                        eventType != null &&
                        (eventType == 'tools' ||
                            eventType == 'tools-res' ||
                            eventType == 'ocr_file_type' ||
                            eventType == 'ocr_result' ||
                            eventType == 'document');

                    if (hasContent || isSpecialEvent) {
                      // 正常消息
                      final event = SSEEvent(
                        type: SSEEventType.message,
                        data: eventData,
                      );
                      streamController.add(event);
                      onMessage(messageData);

                      if (isSpecialEvent && !hasContent) {
                        logPrint('✅ 处理特殊事件: $eventType (无 content)');
                      }
                    } else {
                      logPrint('⏭️ 跳过空内容的消息 (eventType: $eventType)');
                    }
                  } else {
                    // 不是 Map 或 List 类型，直接作为文本消息
                    final event = SSEEvent(
                      type: SSEEventType.message,
                      data: eventData,
                    );
                    streamController.add(event);
                    onMessage(
                      SSEMessageData(content: eventData, eventType: eventType),
                    );
                  }
                } catch (e) {
                  // 如果不是 JSON，直接作为文本消息
                  logPrint('SSE 数据不是 JSON，作为文本处理: $eventData');
                  final event = SSEEvent(
                    type: SSEEventType.message,
                    data: eventData,
                  );
                  streamController.add(event);
                  onMessage(
                    SSEMessageData(content: eventData, eventType: eventType),
                  );
                }
              }
            }
          }
        },
        onError: (error) {
          logPrint('SSE 连接错误: $error');
          if (onError != null) {
            onError(error.toString());
          }
          streamController.addError(error);
        },
        onDone: () {
          logPrint('SSE 连接关闭');
          if (onDone != null) {
            onDone();
          }
          streamController.close();
        },
        cancelOnError: false,
      );

      // 返回一个包装的订阅，用于监听 SSEEvent
      return streamController.stream.listen(
        (event) {
          // 事件已经在上面处理过了，这里不需要再处理
        },
        onError: (error) {
          // 错误已经在上面处理过了
        },
        onDone: () {
          // 完成已经在上面处理过了
          subscription.cancel();
        },
      );
    } catch (e) {
      logPrint('SSE 连接失败: $e');
      if (onError != null) {
        onError(e.toString());
      }
      rethrow;
    }
  }
}
