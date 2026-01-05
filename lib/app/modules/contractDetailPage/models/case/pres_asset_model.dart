class PresAssetModel {
  int? id;
  int? caseId;
  int? documentId;
  int? assetType;
  String? assetName;
  String? channel;
  String? accountInfo;
  double? amount;
  int? quantity;
  String? assetDesc;
  int? effectiveFrom;
  int? effectiveTo;
  int? status;
  String? releasedAt;
  String? remark;
  int? createTime;

  PresAssetModel({
    this.id,
    this.caseId,
    this.documentId,
    this.assetType,
    this.assetName,
    this.channel,
    this.accountInfo,
    this.amount,
    this.quantity,
    this.assetDesc,
    this.effectiveFrom,
    this.effectiveTo,
    this.status,
    this.releasedAt,
    this.remark,
    this.createTime,
  });

  factory PresAssetModel.fromJson(Map<String, dynamic> json) {
    return PresAssetModel(
      id: json['id'],
      caseId: json['caseId'],
      documentId: json['documentId'],
      assetType: json['assetType'],
      assetName: json['assetName'],
      channel: json['channel'],
      accountInfo: json['accountInfo'],
      amount: json['amount'],
      quantity: json['quantity'],
      assetDesc: json['assetDesc'],
      effectiveFrom: json['effectiveFrom'],
      effectiveTo: json['effectiveTo'],
      status: json['status'],
      releasedAt: json['releasedAt'],
      remark: json['remark'],
      createTime: json['createTime'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'caseId': caseId,
      'documentId': documentId,
      'assetType': assetType,
      'assetName': assetName,
      'channel': channel,
      'accountInfo': accountInfo,
      'amount': amount,
      'quantity': quantity,
      'assetDesc': assetDesc,
      'effectiveFrom': effectiveFrom,
      'effectiveTo': effectiveTo,
      'status': status,
      'releasedAt': releasedAt,
      'remark': remark,
      'createTime': createTime,
    };
  }
}
