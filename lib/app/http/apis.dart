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

  ///案件进展
  static String caseTimeline = '/legal/case-timeline/list';

  ///获取案件任务分页
  static String getTaskPage = '/legal/task/page';

  ///获取案件数量
  static String getTaskCount = '/legal/task/get-count';

  ///创建案件任务
  static String createCaseTask = '/legal/task/create';

  ///设置任务的备注
  static String setTaskRemark = '/legal/task/remark';


  ///系统配置
  static String systemConfig = '/system/parameter-config/all';

  ///AI智能体UI配置
  static String agentUIConfig = '/ai/agent-ui-config/get';


}

