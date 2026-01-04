/// id : 64
/// prologue : "你好，我是你的专业法律助手小京～"
/// language : "zh"
/// presetProblem : null
/// useSuggestion : true
/// suggestionProblem : "生成和用户问题和ai回复相关度比较高的问题。"
/// useThinkingBtn : true
/// enableThinking : true
/// useStt : true
/// sttModelId : 78
/// useTts : true
/// ttsModelId : 81
/// ttsTimbre : null
/// bkUrl : "https://cdn.lawseek.cn/background/20251206/109951172080410136_1765003309478.png"
/// userInputType : null
/// createTime : 1765003323000
/// thinkModelId : 74
/// useImg : true
/// vlModelId : 83

class ChatAgentUiConfig {
  ChatAgentUiConfig({
      this.id, 
      this.prologue, 
      this.language, 
      this.presetProblem, 
      this.useSuggestion, 
      this.suggestionProblem, 
      this.useThinkingBtn, 
      this.enableThinking, 
      this.useStt, 
      this.sttModelId, 
      this.useTts, 
      this.ttsModelId, 
      this.ttsTimbre, 
      this.bkUrl, 
      this.userInputType, 
      this.createTime, 
      this.thinkModelId, 
      this.useImg, 
      this.vlModelId,});

  ChatAgentUiConfig.fromJson(dynamic json) {
    id = json['id'];
    prologue = json['prologue'];
    language = json['language'];
    presetProblem = json['presetProblem'];
    useSuggestion = json['useSuggestion'];
    suggestionProblem = json['suggestionProblem'];
    useThinkingBtn = json['useThinkingBtn'];
    enableThinking = json['enableThinking'];
    useStt = json['useStt'];
    sttModelId = json['sttModelId'];
    useTts = json['useTts'];
    ttsModelId = json['ttsModelId'];
    ttsTimbre = json['ttsTimbre'];
    bkUrl = json['bkUrl'];
    userInputType = json['userInputType'];
    createTime = json['createTime'];
    thinkModelId = json['thinkModelId'];
    useImg = json['useImg'];
    vlModelId = json['vlModelId'];
  }
  num? id;
  String? prologue;
  String? language;
  dynamic presetProblem;
  bool? useSuggestion;
  String? suggestionProblem;
  bool? useThinkingBtn;
  bool? enableThinking;
  bool? useStt;
  num? sttModelId;
  bool? useTts;
  num? ttsModelId;
  dynamic ttsTimbre;
  String? bkUrl;
  dynamic userInputType;
  num? createTime;
  num? thinkModelId;
  bool? useImg;
  num? vlModelId;
ChatAgentUiConfig copyWith({  num? id,
  String? prologue,
  String? language,
  dynamic presetProblem,
  bool? useSuggestion,
  String? suggestionProblem,
  bool? useThinkingBtn,
  bool? enableThinking,
  bool? useStt,
  num? sttModelId,
  bool? useTts,
  num? ttsModelId,
  dynamic ttsTimbre,
  String? bkUrl,
  dynamic userInputType,
  num? createTime,
  num? thinkModelId,
  bool? useImg,
  num? vlModelId,
}) => ChatAgentUiConfig(  id: id ?? this.id,
  prologue: prologue ?? this.prologue,
  language: language ?? this.language,
  presetProblem: presetProblem ?? this.presetProblem,
  useSuggestion: useSuggestion ?? this.useSuggestion,
  suggestionProblem: suggestionProblem ?? this.suggestionProblem,
  useThinkingBtn: useThinkingBtn ?? this.useThinkingBtn,
  enableThinking: enableThinking ?? this.enableThinking,
  useStt: useStt ?? this.useStt,
  sttModelId: sttModelId ?? this.sttModelId,
  useTts: useTts ?? this.useTts,
  ttsModelId: ttsModelId ?? this.ttsModelId,
  ttsTimbre: ttsTimbre ?? this.ttsTimbre,
  bkUrl: bkUrl ?? this.bkUrl,
  userInputType: userInputType ?? this.userInputType,
  createTime: createTime ?? this.createTime,
  thinkModelId: thinkModelId ?? this.thinkModelId,
  useImg: useImg ?? this.useImg,
  vlModelId: vlModelId ?? this.vlModelId,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['prologue'] = prologue;
    map['language'] = language;
    map['presetProblem'] = presetProblem;
    map['useSuggestion'] = useSuggestion;
    map['suggestionProblem'] = suggestionProblem;
    map['useThinkingBtn'] = useThinkingBtn;
    map['enableThinking'] = enableThinking;
    map['useStt'] = useStt;
    map['sttModelId'] = sttModelId;
    map['useTts'] = useTts;
    map['ttsModelId'] = ttsModelId;
    map['ttsTimbre'] = ttsTimbre;
    map['bkUrl'] = bkUrl;
    map['userInputType'] = userInputType;
    map['createTime'] = createTime;
    map['thinkModelId'] = thinkModelId;
    map['useImg'] = useImg;
    map['vlModelId'] = vlModelId;
    return map;
  }

}