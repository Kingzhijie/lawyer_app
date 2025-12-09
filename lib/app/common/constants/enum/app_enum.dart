

enum AppChannel {
  web('H5', 'web'),
  apple('苹果', 'apple'),
  xiaomi('小米', 'xiaomi'),
  huawei('华为', 'huawei'),
  vivo('vivo', 'vivo'),
  oppo('oppo', 'oppo'),
  honor('荣耀', 'honor'),
  baidu('百度', 'baidu'),
  common('官方', 'common'),
  yyb('应用宝', 'yyb');
  const AppChannel(this.name, this.channel);
  final String name;
  final String channel;
}

//xiaomi, huawei, vivo, oppo, honor, common, yyb, baidu