class MemberItemModel {
  int? id;
  String? packageName;
  int? salePrice;
  int? originalPrice;
  int? promoPrice;
  String? detailContent;
  bool? hasTeamOffice;
  bool? hasNonLitigation;
  int? sort;
  int? status;
  String? remark;
  int? createTime;

  MemberItemModel({
    this.id,
    this.packageName,
    this.salePrice,
    this.originalPrice,
    this.promoPrice,
    this.detailContent,
    this.hasTeamOffice,
    this.hasNonLitigation,
    this.sort,
    this.status,
    this.remark,
    this.createTime,
  });

  factory MemberItemModel.fromJson(Map<String, dynamic> json) {
    return MemberItemModel(
      id: json['id'] as int?,
      packageName: json['packageName'] as String?,
      salePrice: json['salePrice'] as int?,
      originalPrice: json['originalPrice'] as int?,
      promoPrice: json['promoPrice'] as int?,
      detailContent: json['detailContent'] as String?,
      hasTeamOffice: json['hasTeamOffice'] as bool?,
      hasNonLitigation: json['hasNonLitigation'] as bool?,
      sort: json['sort'] as int?,
      status: json['status'] as int?,
      remark: json['remark'] as String?,
      createTime: json['createTime'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'packageName': packageName,
      'salePrice': salePrice,
      'originalPrice': originalPrice,
      'promoPrice': promoPrice,
      'detailContent': detailContent,
      'hasTeamOffice': hasTeamOffice,
      'hasNonLitigation': hasNonLitigation,
      'sort': sort,
      'status': status,
      'remark': remark,
      'createTime': createTime,
    };
  }
}
