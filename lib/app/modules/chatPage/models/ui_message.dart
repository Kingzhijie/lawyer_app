
class MessageFileModel {
  final String? url;
  final String? path;
  final String? name;

  MessageFileModel({this.path, this.url, this.name});

  MessageFileModel copyWith({
    String? url,
    String? path,
    String? name,
  }) {
    return MessageFileModel(
      path: path ?? this.path,
      url: url ?? this.url,
      name: name ?? this.name,
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
    List<MessageFileModel>? files,
    List<MessageImageModel>? images,
  }) {
    return UiMessage(
      id: id ?? this.id,
      text: text ?? this.text,
      isAi: isAi ?? this.isAi,
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