/// SSE 新格式使用示例
///
/// AI 回复的新格式包含两种事件类型：
/// 1. event:document - 包含文档内容和元数据
/// 2. event:message - 包含逐字流式回复内容

import 'sse_utils.dart';

/// 使用示例
void exampleUsage() async {
  final sseUtils = SSEUtils();

  // 创建请求
  final request = SSEChatRequest(
    message: '请帮我分析这个案例',
    requestId: 'unique-request-id-${DateTime.now().millisecondsSinceEpoch}',
    hisId: 123,
    think: true,
  );

  // 用于累积回复内容
  String accumulatedReply = '';
  String accumulatedThinking = '';
  List<Map<String, dynamic>> documents = [];

  // 发起 SSE 连接
  final subscription = await sseUtils.chatStream(
    agentId: 'your-agent-id',
    request: request,
    onMessage: (SSEMessageData data) {
      // 根据事件类型处理不同的数据

      if (data.isDocument) {
        // 处理 document 事件
        print('📄 收到文档:');
        print('  - 文档名称: ${data.documentName}');
        print('  - 文档 URL: ${data.documentUrl}');
        print('  - 内容长度: ${data.content?.length ?? 0} 字符');

        // 保存文档信息
        documents.add({
          'name': data.documentName,
          'url': data.documentUrl,
          'content': data.content,
        });
      } else if (data.isMessage) {
        // 处理 message 事件（流式回复）

        // 累积回复内容
        if (data.content != null && data.content!.isNotEmpty) {
          accumulatedReply += data.content!;
          print('💬 收到回复片段: ${data.content}');
          print('📊 累积回复长度: ${accumulatedReply.length} 字符');
        }

        // 累积思考内容
        if (data.reasoningContent != null &&
            data.reasoningContent!.isNotEmpty) {
          accumulatedThinking += data.reasoningContent!;
          print('🤔 收到思考片段: ${data.reasoningContent}');
          print('📊 累积思考长度: ${accumulatedThinking.length} 字符');
        }
      } else {
        // 其他事件类型
        print('📨 收到其他事件: ${data.eventType}');
      }
    },
    onError: (String error) {
      print('❌ 错误: $error');
    },
    onDone: () {
      print('✅ 完成');
      print('最终回复: $accumulatedReply');
      print('最终思考: $accumulatedThinking');
      print('文档数量: ${documents.length}');
    },
  );

  // 如果需要取消订阅
  // await subscription.cancel();
}

/// 在 UI 中使用的示例
class ChatController {
  String replyText = '';
  String thinkingText = '';
  List<Map<String, dynamic>> documents = [];

  void startChat(String message) async {
    // 重置状态
    replyText = '';
    thinkingText = '';
    documents.clear();

    final sseUtils = SSEUtils();
    final request = SSEChatRequest(
      message: message,
      requestId: 'req-${DateTime.now().millisecondsSinceEpoch}',
      think: true,
    );

    await sseUtils.chatStream(
      agentId: 'your-agent-id',
      request: request,
      onMessage: (data) {
        if (data.isDocument) {
          // 添加文档到列表
          documents.add({
            'name': data.documentName,
            'url': data.documentUrl,
            'content': data.content,
          });
          // 更新 UI
          updateUI();
        } else if (data.isMessage) {
          // 累积回复内容
          if (data.content != null) {
            replyText += data.content!;
          }
          if (data.reasoningContent != null) {
            thinkingText += data.reasoningContent!;
          }
          // 更新 UI
          updateUI();
        }
      },
      onError: (error) {
        print('错误: $error');
        // 显示错误提示
      },
      onDone: () {
        print('对话完成');
        // 标记完成状态
      },
    );
  }

  void updateUI() {
    // 在这里更新 UI，例如使用 setState() 或 update()
    // setState(() {});
    // 或 update();
  }
}
