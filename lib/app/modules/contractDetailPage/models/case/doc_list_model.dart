class DocListModel {
  String? fileUrl;
  String? fileName;
  int? caseId;
  dynamic fileTypeCode;
  String? docTitle;
  int? updateTime;

  DocListModel({
    this.fileUrl,
    this.fileName,
    this.caseId,
    this.fileTypeCode,
    this.docTitle,
    this.updateTime,
  });

  factory DocListModel.fromJson(Map<String, dynamic> json) => DocListModel(
    fileUrl: json['fileUrl'] as String?,
    fileName: json['fileName'] as String?,
    caseId: json['caseId'] as int?,
    fileTypeCode: json['fileTypeCode'] as dynamic,
    docTitle: json['docTitle'] as String?,
    updateTime: json['updateTime'] as int?,
  );

  Map<String, dynamic> toJson() => {
    'fileUrl': fileUrl,
    'fileName': fileName,
    'caseId': caseId,
    'fileTypeCode': fileTypeCode,
    'docTitle': docTitle,
    'updateTime': updateTime,
  };
}
