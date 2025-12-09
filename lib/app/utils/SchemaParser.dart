// utils/schema_parser.dart


import '../config/app_config.dart';

class SchemaParser {
  // 解析 Schema URL: myapp://page/home?id=13&name=12
  static SchemaResult? parse(String url) {
    try {
      if (url.isEmpty) return null;

      final uri = Uri.parse(url);


      // 检查 schema 是否符合预期
      if (uri.scheme != AppConfig.appScheme) {
        return null;
      }

      final page = uri.path; // home
      final params = uri.queryParameters; // {id: '13', name: '12'}

      return SchemaResult(
        schema: uri.scheme,
        page: page,
        params: params,
        originalUrl: url,
      );
    } catch (e) {
      print('解析 Schema 失败: $e');
      return null;
    }
  }

  // 生成 Schema URL
  static String generate({
    required String page,
    required Map<String, String> params,
    String schema = 'myapp',
  }) {
    final uri = Uri(
      scheme: schema,
      host: 'page',
      path: page,
      queryParameters: params.isNotEmpty ? params : null,
    );
    return uri.toString();
  }
}

class SchemaResult {
  final String schema;
  final String page;
  final Map<String, String> params;
  final String originalUrl;

  SchemaResult({
    required this.schema,
    required this.page,
    required this.params,
    required this.originalUrl,
  });

  @override
  String toString() {
    return 'SchemaResult(schema: $schema, page: $page, params: $params)';
  }
}