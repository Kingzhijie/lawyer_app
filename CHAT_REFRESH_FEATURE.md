# 聊天刷新功能

## 功能说明
点击刷新按钮，移除最后一条 AI 回复，并重新发送上一条用户消息让 AI 重新回复。

## 实现逻辑

### 1. ChatBubbleLeft 组件
添加 `onRefresh` 回调参数：

```dart
class ChatBubbleLeft extends StatefulWidget {
  const ChatBubbleLeft({
    // ...
    this.onRefresh, // 刷新回调
  });

  final VoidCallback? onRefresh;
}
```

刷新按钮调用回调：

```dart
_buildActionButton(Icons.refresh, () {
  widget.onRefresh?.call();
}),
```

### 2. ChatPageController
添加 `refreshLastAiMessage()` 方法：

```dart
void refreshLastAiMessage() {
  // 1. 找到最后一条 AI 消息（排除开场白）
  final lastAiIndex = messages.lastIndexWhere((m) => m.isAi && !m.isPrologue);
  
  // 2. 找到这条 AI 消息之前的最后一条用户消息
  final lastUserIndex = messages.lastIndexWhere(
    (m) => !m.isAi,
    lastAiIndex - 1,
  );
  
  // 3. 移除最后一条 AI 消息
  messages.removeAt(lastAiIndex);
  
  // 4. 重新发送用户消息
  _sendMessageWithSSE(lastUserMessage.text, sessionId.value!);
}
```

### 3. ChatPageView
只在最后一条 AI 消息时传入刷新回调：

```dart
ChatBubbleLeft(
  message: msg,
  isLastAiMessage: isLastAiMessage,
  onRefresh: isLastAiMessage
      ? () => controller.refreshLastAiMessage()
      : null,
  // ...
)
```

## 执行流程

```
用户点击刷新按钮
    ↓
调用 widget.onRefresh?.call()
    ↓
执行 controller.refreshLastAiMessage()
    ↓
1. 找到最后一条 AI 消息
    ↓
2. 找到对应的用户消息
    ↓
3. 移除 AI 消息
    ↓
4. 重新发送用户消息
    ↓
AI 重新生成回复
```

## 使用场景

### 场景 1：AI 回复不满意
```
用户: 帮我分析这个案例
AI: [回复内容不满意]
用户: [点击刷新按钮]
AI: [重新生成回复]
```

### 场景 2：AI 回复出错
```
用户: 请提供法律建议
AI: [回复出现错误]
用户: [点击刷新按钮]
AI: [重新生成正确回复]
```

## 注意事项

1. **只在最后一条显示**：刷新按钮只在最后一条 AI 消息时显示
2. **排除开场白**：不会刷新开场白消息
3. **保留用户消息**：只移除 AI 消息，用户消息保留
4. **重用 sessionId**：使用相同的会话 ID 重新发送
5. **取消之前的连接**：`_sendMessageWithSSE` 会自动取消之前的 SSE 连接

## 边界情况处理

- ✅ 没有 AI 消息：不执行刷新
- ✅ 没有用户消息：不执行刷新
- ✅ sessionId 为空：不执行刷新
- ✅ 正在回复中：按钮不显示（通过 `isThinkingDone` 控制）

## 日志输出

```
🔄 刷新最后一条 AI 回复
📝 找到用户消息: [用户消息内容]
🗑️ 已移除 AI 消息
🔄 重新发送消息
```
