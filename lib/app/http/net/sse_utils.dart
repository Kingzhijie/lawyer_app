import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:lawyer_app/app/http/net/tool/dio_utils.dart';
import '../../config/dio_config.dart';
import '../../utils/storage_utils.dart';
import 'tool/logger.dart';

/// SSE 消息数据模型
class SSEMessageData {
  final String? content;
  final String? reasoningContent;
  final String? phase;
  final String? status;
  final String? role;

  SSEMessageData({
    this.content,
    this.reasoningContent,
    this.phase,
    this.status,
    this.role,
  });

  factory SSEMessageData.fromJson(Map<String, dynamic> json) {
    return SSEMessageData(
      content: json['content']?.toString(),
      reasoningContent: json['reasoningContent']?.toString(),
      phase: json['phase']?.toString(),
      status: json['status']?.toString(),
      role: json['role']?.toString(),
    );
  }
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

  SSEFileModel({
    required this.url,
    required this.name,
  });

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'name': name,
    };
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

  SSEEvent({
    required this.type,
    required this.data,
    this.error,
  });
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
      final dio = Dio(BaseOptions(
        baseUrl: DioConfig.baseURL,
        connectTimeout: DioConfig.connectTimeout,
        receiveTimeout: Duration(minutes: 5), // SSE 需要更长的超时时间
        sendTimeout: DioConfig.sendTimeout,
      ));
      
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
        options: Options(
          headers: headers,
          responseType: ResponseType.stream,
        ),
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
            
            // 跳过 tools 事件
            if (eventType == 'tools') {
              logPrint('⏭️ 跳过 tools 事件');
              continue;
            }
            
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
                  } else if (json is Map) {
                    // 解析消息数据
                    final messageData = SSEMessageData.fromJson(Map<String, dynamic>.from(json));
                    
                    logPrint('解析后的数据 - content: ${messageData.content}, reasoningContent: ${messageData.reasoningContent}');
                    
                    // 检查是否有实际内容（content 或 reasoningContent）
                    final hasContent = (messageData.content != null && messageData.content!.isNotEmpty) ||
                                      (messageData.reasoningContent != null && messageData.reasoningContent!.isNotEmpty);
                    
                    if (hasContent) {
                      // 正常消息
                      final event = SSEEvent(
                        type: SSEEventType.message,
                        data: eventData,
                      );
                      streamController.add(event);
                      onMessage(messageData);
                    } else {
                      logPrint('跳过空内容的消息');
                    }
                  } else {
                    // 不是 Map 类型，直接作为文本消息
                    final event = SSEEvent(
                      type: SSEEventType.message,
                      data: eventData,
                    );
                    streamController.add(event);
                    onMessage(SSEMessageData(content: eventData));
                  }
                } catch (e) {
                  // 如果不是 JSON，直接作为文本消息
                  logPrint('SSE 数据不是 JSON，作为文本处理: $eventData');
                  final event = SSEEvent(
                    type: SSEEventType.message,
                    data: eventData,
                  );
                  streamController.add(event);
                  onMessage(SSEMessageData(content: eventData));
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
