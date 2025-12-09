enum AppAgreement {
  userAgreement('https://www.miliyue.com/about/user.html', '用户服务协议', 'https://www.miliyue.com/about/user_en.html'),
  privacyServiceAgreement(
      'https://www.miliyue.com/about/policy.html', '隐私政策', 'https://www.miliyue.com/about/policy_en.html'),
  partyServiceAgreement(
      'https://miyue360.pages.dev/agreement/agreement.html', '线上聚会服务协议', 'https://miyue360.pages.dev/agreement/agreement_en.html'),
  vipServiceAgreement(
      'https://www.miliyue.com/about/vip.html', 'vip协议', 'https://www.miliyue.com/about/vip_en.html'),;

  const AppAgreement(this.url, this.name, this.enUrl);

  final String url;
  final String name;
  final String enUrl;

  //https://www.miliyue.com/about/vip.html
}


enum ContentConfigKey {//
  aboutUs('customer_about_us', '关于我们'),
  accountCancel('account_cancel', '账户注销'),
  accountCancelAlert('account_cancel_alert', '账户注销弹框提醒'),
  antiFraudGuide('guide', '防骗指南'),
  usageSpecifications('usage_specifications', '平台使用规范'),
  inviteRewardRule('invite_reward_rule', '邀请奖励规则');

  const ContentConfigKey(this.key, this.name);
  final String key;
  final String name;
}