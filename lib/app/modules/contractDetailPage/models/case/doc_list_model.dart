import 'file.dart';

class DocListModel {
  List<File>? files;
  int? caseId;
  String? fileTypeCode;
  String? docTitle;
  int? updateTime;

  DocListModel({
    this.files,
    this.caseId,
    this.fileTypeCode,
    this.docTitle,
    this.updateTime,
  });

  factory DocListModel.fromJson(Map<String, dynamic> json) {
    return DocListModel(
      files: (json['files'] as List<dynamic>?)
          ?.map((e) => File.fromJson(e as Map<String, dynamic>))
          .toList(),
      caseId: json['caseId'] as int?,
      fileTypeCode: json['fileTypeCode'] as String?,
      docTitle: json['docTitle'] as String?,
      updateTime: json['updateTime'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'files': files?.map((e) => e.toJson()).toList(),
      'caseId': caseId,
      'fileTypeCode': fileTypeCode,
      'docTitle': docTitle,
      'updateTime': updateTime,
    };
  }
}
