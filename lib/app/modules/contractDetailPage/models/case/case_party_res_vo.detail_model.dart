class CasePartyResVo {
  int? id;
  String? name;
  int? partyRole;

  CasePartyResVo({this.id, this.name, this.partyRole});

  factory CasePartyResVo.fromJson(Map<String, dynamic> json) {
    return CasePartyResVo(
      id: json['id'] as int?,
      name: json['name'] as String?,
      partyRole: json['partyRole'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'partyRole': partyRole,
  };
}
