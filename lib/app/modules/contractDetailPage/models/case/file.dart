class File {
  String? fileUrl;
  String? fileName;

  File({this.fileUrl, this.fileName});

  factory File.fromJson(Map<String, dynamic> json) {
    return File(
      fileUrl: json['fileUrl'] as String?,
      fileName: json['fileName'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'fileUrl': fileUrl, 'fileName': fileName};
  }
}
