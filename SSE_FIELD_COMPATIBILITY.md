# SSE 字段兼容性说明

## 问题
后端 SSE 返回的数据格式有两种字段命名：

### 格式 1（旧格式）
```json
{
  "content": "回复内容",
  "reasoningContent": "思考过程",
  "role": "assistant"
}
```

### 格式 2（新格式）
```json
{
  "text": "回复内容",
  "think": "思考过程",
  "functionCall": []
}
```

## 解决方案

已更新 `SSEMessageData.fromJson` 方法，**自动兼容两种格式**：

```dart
// 兼容 content 和 text 字段
content = json['content']?.toString() ?? json['text']?.toString();

// 兼容 reasoningContent 和 think 字段
reasoningContent = json['reasoningContent']?.toString() ?? json['think']?.toString();
```

## 字段映射

| 用途 | 格式 1 | 格式 2 | SSEMessageData 属性 |
|------|--------|--------|---------------------|
| 回复内容 | `content` | `text` | `content` |
| 思考过程 | `reasoningContent` | `think` | `reasoningContent` |

## 使用方式

**无需修改任何业务代码**，继续使用统一的属性：

```dart
onMessage: (data) {
  // 自动兼容两种格式
  if (data.content != null) {
    print('回复: ${data.content}');
  }
  
  if (data.reasoningContent != null) {
    print('思考: ${data.reasoningContent}');
  }
}
```

## 测试结果

### 格式 1 测试
```json
{"content":"你好","reasoningContent":"正在思考..."}
```
✅ 正常解析：`content = "你好"`, `reasoningContent = "正在思考..."`

### 格式 2 测试
```json
{"text":"你好","think":"正在思考...","functionCall":[]}
```
✅ 正常解析：`content = "你好"`, `reasoningContent = "正在思考..."`

## 优先级

如果同时存在两种字段（不太可能），优先使用格式 1：
- `content` 优先于 `text`
- `reasoningContent` 优先于 `think`

## 注意事项

1. 这个兼容性处理是**透明的**，业务代码无需修改
2. 支持**渐进式迁移**，新旧格式可以共存
3. 建议后端统一使用一种格式，避免混淆
