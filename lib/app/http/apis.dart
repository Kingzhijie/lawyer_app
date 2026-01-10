class Apis {
  //上传图片
  static String uploadSingleImage = '/infra/file/upload';
  //上传音频
  static String uploadAudio = '/common/uploadAudio';

  ///发送手机验证码
  static String sendSmsCode = '/member/auth/send-sms-code';

  ///验证码登录
  static String smsLogin = '/member/auth/sms-login';

  ///刷新token
  static String refreshToken = '/member/auth/refresh-token';

  ///获取用户基本信息
  static String getUserInfo = '/member/user/get';

  ///编辑用户基本信息
  static String editUserInfo = '/member/user/update';

  ///首页数据看板
  static String homeStatistics = '/legal/kanban/statistics';

  ///创建案件基本信息
  static String createCaseBasicInfo = '/legal/case-basic-info/create';

  ///案件基本信息列表
  static String caseBasicInfoList = '/legal/case-basic-info/page';

  ///搜索案件
  static String searchCaseInfoList = '/legal/case-basic-info/page-simple';

  ///案件基本信息
  static String caseBasicInfo = '/legal/case-basic-info/get';

  ///更新案件基本信息
  static String updateCaseBasicInfo = '/legal/case-basic-info/update';

  ///案件操作（归档/上诉/删除）
  static String caseOperator = '/legal/case-basic-info/operate';

  ///案件进展
  static String caseTimeline = '/legal/case-timeline/list';

  ///待办
  static String todoCaseList = '/legal/task/list';

  ///当事人角色列表
  static String partyRoleList = '/legal/case-party/role-list';

  ///新增当事人
  static String createPartyRole = '/legal/case-party/create';

  ///新增律师费记录
  static String createAgencyFee = '/legal/agency-fee/create';

  ///编辑律师费记录
  static String updateAgencyFee = '/legal/agency-fee/update';

  ///获取案件任务分页
  static String getTaskPage = '/legal/task/page';

  ///上传文书
  static String uploadDocument = '/legal/document/create';

  ///当事人列表
  static String casePartyList = '/legal/case-party/party-page';

  ///保全清单列表
  static String preservationAssetList = '/legal/preservation-asset/page';

  ///保全清单Tab统计
  static String preservationAssetTabCount =
      '/legal/preservation-asset/tab-count';

  ///保全清单详情
  static String preservationAssetDetail = '/legal/preservation-asset/get';

  ///添加/编辑保全资产备注
  static String preservationAssetNote = '/legal/preservation-asset/note';

  ///添加保全资产提醒
  static String addCalendarPreservationAsset =
      '/legal/preservation-asset/addCalendar';

  ///获得个人分销统计(邀请记录)
  static String brokerageUserSummary = '/member/brokerage-user/get-summary';

  ///获得下级分销统计分页
  static String brokerageUserChildSummary =
      '/member/brokerage-user/child-summary-page';

  ///会员套餐列表
  static String memberPageList = '/member/package/page';

  ///创建会员订单
  static String createMemberOrder = '/member/package-order/create';

  ///会员套餐订单
  static String memberOrder = '/member/package-order/get';

  ///会员邀请活动
  static String inviteActivity = '/member/invite-activity/get';

  ///获取案件数量
  static String getTaskCount = '/legal/task/get-count';

  ///创建案件任务
  static String createCaseTask = '/legal/task/create';

  ///设置任务的备注
  static String setTaskRemark = '/legal/task/remark';

  ///搜索用户列表
  static String searchUserList = '/member/user/list';

  ///关联用户
  static String relateUser = '/legal/manager/relate-user';

  ///创建聊天id
  static String createChatId = '/ai/chat-his/create';

  ///任务添加到日历提醒
  static String taskAddCalendar = '/legal/task/addCalendar';

  ///系统配置
  static String systemConfig = '/system/parameter-config/all';

  ///AI智能体UI配置
  static String agentUIConfig = '/ai/agent-ui-config/get';

  ///获取历史消息
  static String getAiHistoryList = '/ai/chat-his/page';

  ///获取对话详细内容
  static String getAiChatContentList = '/ai/chat-msg/list';

  ///删除历史消息
  static String deleteAiHistory = '/ai/chat-his/delete';

  ///AI智能体聊天流式接口
  static String aiChatStream(String agentId) =>
      '/ai/super-agent/chat/stream/$agentId';
}
