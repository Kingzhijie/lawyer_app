class Party {
  int? partyId;
  String? name;
  int? partyRole;
  String? partyRoleName;

  Party({this.partyId, this.name, this.partyRole, this.partyRoleName});

  factory Party.fromJson(Map<String, dynamic> json) {
    return Party(
      partyId: json['partyId'] as int?,
      name: json['name'] as String?,
      partyRole: json['partyRole'] as int?,
      partyRoleName: json['partyRoleName'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'partyId': partyId,
      'name': name,
      'partyRole': partyRole,
      'partyRoleName': partyRoleName,
    };
  }
}
