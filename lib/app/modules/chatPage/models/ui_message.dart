
class MessageFileModel {
  final String? url;
  final String? path;
  final String? name;
  final String? type;

  MessageFileModel({this.path, this.url, this.name, this.type});

  MessageFileModel copyWith({
    String? url,
    String? path,
    String? name,
    String? type,
  }) {
    return MessageFileModel(
      path: path ?? this.path,
      url: url ?? this.url,
      name: name ?? this.name,
        type: type ?? this.type
    );
  }
}

class MessageImageModel {
  final String? url;
  final String? path;

  MessageImageModel({this.path, this.url});

  MessageImageModel copyWith({
    String? url,
    String? path,
  }) {
    return MessageImageModel(
      path: path ?? this.path,
      url: url ?? this.url,
    );
  }
}

class UiMessage {
  UiMessage({
    required this.id,
    required this.text,
    required this.isAi,
    required this.createdAt,
    this.hasAnimated = false,
    this.thinkingProcess,
    this.thinkingSeconds,
    this.isThinkingDone = false,
    this.isPrologue = false,
    this.files,
    this.images,
    this.caseId,
    this.isHiddenRefresh = false
  });

  final String id;
  final String text;
  final bool isAi;
  final DateTime createdAt;
  final bool hasAnimated;
  final String? thinkingProcess; // 思考过程内容
  final int? thinkingSeconds; // 思考用时
  final bool isThinkingDone; // 思考是否完成
  final bool isPrologue; // 是否开场白
  final List<MessageFileModel>? files; // 文件数组
  final List<MessageImageModel>? images; // 图片数组
  final int? caseId;
  final bool isHiddenRefresh;

  UiMessage copyWith({
    String? id,
    String? text,
    bool? isAi,
    DateTime? createdAt,
    bool? hasAnimated,
    String? thinkingProcess,
    int? thinkingSeconds,
    bool? isThinkingDone,
    bool? isPrologue,
    int? caseId,
    bool? isHiddenRefresh,
    List<MessageFileModel>? files,
    List<MessageImageModel>? images,
  }) {
    return UiMessage(
      id: id ?? this.id,
      caseId: caseId ?? this.caseId,
      text: text ?? this.text,
      isAi: isAi ?? this.isAi,
      isHiddenRefresh: isHiddenRefresh ?? this.isHiddenRefresh,
      createdAt: createdAt ?? this.createdAt,
      hasAnimated: hasAnimated ?? this.hasAnimated,
      thinkingProcess: thinkingProcess ?? this.thinkingProcess,
      thinkingSeconds: thinkingSeconds ?? this.thinkingSeconds,
      isThinkingDone: isThinkingDone ?? this.isThinkingDone,
      isPrologue: isPrologue ?? this.isPrologue,
      files: files != null 
          ? files.map((f) => f.copyWith()).toList() 
          : (this.files != null ? this.files!.map((f) => f.copyWith()).toList() : null),
      images: images != null 
          ? images.map((img) => img.copyWith()).toList() 
          : (this.images != null ? this.images!.map((img) => img.copyWith()).toList() : null),
    );
  }
}