# SSE OCR 事件支持

## 概述
已扩展 `SSEMessageData` 模型以支持 OCR（光学字符识别）相关的 SSE 事件。

## 新增的 OCR 事件类型

### 1. `ocr_file_type` 事件
- 表示正在识别文件类型
- 通常没有具体数据，只是通知开始识别

### 2. `ocr_result` 事件
- 包含完整的 OCR 识别结果
- 数据结构：
```json
{
  "files": [
    {
      "fileUrl": "https://...",
      "fileName": "document.jpg"
    }
  ],
  "ocrResultDTO": {
    "fileTypeCode": "zxfjntzs",
    "result": {
      "执行案号": "...",
      "执行法院": "...",
      "被执行人": "...",
      ...
    },
    "errorMsg": null
  },
  "caseId": null,
  "userId": null
}
```

## 新增的属性和方法

### 判断方法
```dart
bool get isOcrFileType  // 是否是 OCR 文件类型事件
bool get isOcrResult    // 是否是 OCR 结果事件
```

### 数据获取方法
```dart
// 获取完整的 OCR 数据
Map<String, dynamic>? get ocrResultData

// 获取文件列表
List<Map<String, dynamic>>? get ocrFiles

// 获取识别结果
Map<String, dynamic>? get ocrResult

// 获取文件类型代码
String? get ocrFileTypeCode

// 获取错误信息
String? get ocrErrorMsg

// 获取关联的案件 ID（重要！）
num? get ocrCaseId

// 获取关联的用户 ID
num? get ocrUserId
```

## 使用示例

### 基本用法
```dart
onMessage: (SSEMessageData data) {
  if (data.isOcrFileType) {
    print('🔍 正在识别文件类型...');
  } 
  else if (data.isOcrResult) {
    print('📋 收到 OCR 识别结果');
    
    // 获取案件 ID（重要！）
    final caseId = data.ocrCaseId;
    if (caseId != null) {
      print('关联案件 ID: $caseId');
      // 可以跳转到案件详情或关联案件
    }
    
    print('文件类型: ${data.ocrFileTypeCode}');
    print('识别结果: ${data.ocrResult}');
    
    if (data.ocrErrorMsg != null) {
      print('错误: ${data.ocrErrorMsg}');
    }
  }
}
```

### 在控制器中使用
```dart
class ChatController {
  Map<String, dynamic>? currentOcrResult;
  num? currentCaseId;
  
  void handleOcrEvent(SSEMessageData data) {
    if (data.isOcrResult) {
      currentOcrResult = data.ocrResult;
      currentCaseId = data.ocrCaseId;
      
      // 如果有案件 ID，可以跳转到案件详情
      if (currentCaseId != null) {
        Get.toNamed('/case-detail', arguments: {'caseId': currentCaseId});
      }
      
      // 根据文件类型处理
      switch (data.ocrFileTypeCode) {
        case 'zxfjntzs': // 执行法院缴费通知书
          displayExecutionNotice(currentOcrResult, currentCaseId);
          break;
        default:
          displayGenericResult(currentOcrResult, currentCaseId);
      }
    }
  }
}
```

## 支持的文件类型

根据日志，目前支持的文件类型包括：
- `zxfjntzs` - 执行法院缴费通知书
- 更多类型待补充...

## 注意事项

1. OCR 事件的数据不在 `content` 字段中，而是在 `data` 字段中
2. 使用 `ocrResult` 获取识别的字段数据
3. 始终检查 `ocrErrorMsg` 以处理识别失败的情况
4. OCR 结果的字段根据文件类型不同而不同

## 完整示例

查看 `lib/app/http/net/sse_ocr_example.dart` 获取完整的使用示例。
