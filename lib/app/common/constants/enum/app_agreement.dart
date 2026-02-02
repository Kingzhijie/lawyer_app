enum AppAgreement {
  userAgreement('https://www.miliyue.com/about/user.html', '用户服务协议'),
  website('https://www.miliyue.com/about/user.html', '用户服务协议');

  const AppAgreement(this.url, this.name);

  final String url;
  final String name;

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