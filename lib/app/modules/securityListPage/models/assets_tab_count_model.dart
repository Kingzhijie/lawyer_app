class AssetsTabCountModel {
  int? totalCount;
  int? expiry60Count;
  int? expiry45Count;
  int? expiry30Count;

  AssetsTabCountModel({
    this.totalCount,
    this.expiry60Count,
    this.expiry45Count,
    this.expiry30Count,
  });

  factory AssetsTabCountModel.fromJson(Map<String, dynamic> json) {
    return AssetsTabCountModel(
      totalCount: json['totalCount'] as int?,
      expiry60Count: json['expiry60Count'] as int?,
      expiry45Count: json['expiry45Count'] as int?,
      expiry30Count: json['expiry30Count'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalCount': totalCount,
      'expiry60Count': expiry60Count,
      'expiry45Count': expiry45Count,
      'expiry30Count': expiry30Count,
    };
  }
}
