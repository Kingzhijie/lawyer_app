# 聊天操作按钮显示逻辑更新

## 需求
操作按钮（刷新、复制）只在**最后一条 AI 消息**时显示，而不是每条 AI 消息都显示。

## 修改内容

### 1. ChatBubbleLeft 组件
添加 `isLastAiMessage` 参数：

```dart
class ChatBubbleLeft extends StatefulWidget {
  const ChatBubbleLeft({
    super.key,
    required this.message,
    required this.onAnimated,
    required this.onTick,
    this.isLastAiMessage = false, // 新增参数
  });

  final bool isLastAiMessage; // 是否是最后一条 AI 消息
  // ...
}
```

### 2. 操作按钮显示条件
更新显示条件，增加 `isLastAiMessage` 判断：

```dart
// 只在最后一条 AI 消息且回复完成时显示操作按钮
if (!widget.message.isPrologue &&
    widget.message.isThinkingDone &&
    widget.isLastAiMessage)  // 新增条件
  Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      _buildActionButton(Icons.refresh, () {}),
      SizedBox(width: 12.toW),
      _buildActionButton(Icons.copy, () {}),
    ],
  ),
```

### 3. 使用时传入参数
在 `chat_page_view.dart` 中判断并传入：

```dart
itemBuilder: (context, index) {
  final msg = reversedMessages[index];
  if (msg.isAi) {
    // 判断是否是最后一条 AI 消息
    // 在反转列表中，第一条 AI 消息就是最后一条
    final isLastAiMessage = index == reversedMessages.indexWhere((m) => m.isAi);
    
    return ChatBubbleLeft(
      message: msg,
      isLastAiMessage: isLastAiMessage, // 传入判断结果
      onAnimated: () => controller.markMessageAnimated(msg.id),
      onTick: () {},
    );
  }
  // ...
}
```

## 显示逻辑

### 显示条件（同时满足）
1. ✅ 不是开场白（`!isPrologue`）
2. ✅ AI 回复已完成（`isThinkingDone`）
3. ✅ **是最后一条 AI 消息**（`isLastAiMessage`）

### 效果
```
用户: 你好
AI: 你好！有什么可以帮您？        [无按钮]

用户: 帮我分析案例
AI: 好的，请提供案例详情。        [无按钮]

用户: ...
AI: 根据您提供的信息...           [🔄 复制] ← 只有最后一条显示
```

## 注意事项

1. **反转列表**：聊天列表是反转的（最新消息在上），所以第一条 AI 消息就是最后一条
2. **动态更新**：当新的 AI 消息到来时，旧消息的按钮会自动隐藏
3. **开场白**：开场白消息永远不显示操作按钮
4. **思考中**：正在回复的消息不显示操作按钮

## 测试场景

- ✅ 多轮对话，只有最后一条 AI 消息显示按钮
- ✅ 新消息到来时，旧消息按钮消失
- ✅ 开场白不显示按钮
- ✅ 正在回复中不显示按钮
