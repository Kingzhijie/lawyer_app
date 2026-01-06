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

  ///AI智能体聊天流式接口
  static String aiChatStream(String agentId) =>
      '/ai/super-agent/chat/stream/$agentId';
}
