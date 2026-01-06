# 本地化更新说明

## 问题
MarkdownBody 长按时显示的菜单文本（如 "Copy"）是英文，需要改成中文（如 "复制"）。

## 解决方案

### 1. 添加 flutter_localizations 依赖
在 `pubspec.yaml` 中添加：
```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_localizations:
    sdk: flutter
```

### 2. 更新 intl 版本
由于 `flutter_localizations` 依赖 `intl ^0.20.2`，需要更新：
- 主项目 `pubspec.yaml`: `intl: ^0.20.2`
- 本地插件 `plugins/flutter_advanced_calendar-1.4.3/pubspec.yaml`: `intl: ^0.20.0`

### 3. 配置本地化代理
在 `lib/main_page.dart` 的 `GetMaterialApp` 中添加：
```dart
import 'package:flutter_localizations/flutter_localizations.dart';
import 'generated/l10n.dart';

GetMaterialApp(
  locale: const Locale('zh', 'CN'),
  localizationsDelegates: const [
    S.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
  supportedLocales: S.delegate.supportedLocales,
  // ... 其他配置
)
```

## 效果
现在 MarkdownBody 和其他 Flutter 组件的长按菜单会显示中文：
- Copy → 复制
- Paste → 粘贴
- Cut → 剪切
- Select All → 全选

## 注意事项
- 需要重新运行 `flutter pub get`
- 需要重启应用才能看到效果
- 这个配置会影响整个应用的系统文本本地化
