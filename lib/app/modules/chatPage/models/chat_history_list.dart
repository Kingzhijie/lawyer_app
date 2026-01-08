/// id : 18962
/// agentId : 64
/// subject : "按键帮我查找一份案件"
/// createTime : 1767797888000

class ChatHistoryList {
  ChatHistoryList({
      this.id, 
      this.agentId, 
      this.subject, 
      this.createTime,});

  ChatHistoryList.fromJson(dynamic json) {
    id = json['id'];
    agentId = json['agentId'];
    subject = json['subject'];
    createTime = json['createTime'];
  }
  num? id;
  num? agentId;
  String? subject;
  num? createTime;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['agentId'] = agentId;
    map['subject'] = subject;
    map['createTime'] = createTime;
    return map;
  }

}