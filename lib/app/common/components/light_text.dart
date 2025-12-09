/* @Author: hpp
 * @Date: 2023-11-01
 * @Description:高亮富文本
 */

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../utils/object_utils.dart';

// ignore: must_be_immutable
class LightText extends StatelessWidget {
  final String titileStr;
  final String text; // 要显示的内容
  final TextStyle? textStyle; // 要显示的内容的文本风格
  final TextStyle? lightStyle; // 要显示的内容中，需要高亮显示的文字的文本风格
  final int? maxlines;
  final TextAlign? textAlign;
  final List<String>? lightTexts; //高亮的数组
  final Function(String text)? onTapLightText; //点击高亮文字事件
  const LightText(
      {super.key,
      required this.text,
      this.textStyle,
      this.lightStyle,
      this.titileStr = '',
      this.maxlines,
      this.lightTexts,
      this.textAlign,
      this.onTapLightText});

  @override
  Widget build(BuildContext context) {
    // 默认普通文本的样式
    TextStyle defTextStyle =
        TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.surface);
    // 默认高亮文本的样式
    TextStyle defLightStyle = TextStyle(
        fontSize: 16, color: Theme.of(context).colorScheme.inverseSurface);
    // 如果没有需要高亮显示的内容
    if (ObjectUtils.isEmpty(lightTexts)) {
      if (titileStr.isNotEmpty) {
        return RichText(
          textAlign: textAlign ?? TextAlign.start,
          maxLines: maxlines ?? 1000,
          overflow: TextOverflow.ellipsis,
          text: TextSpan(children: [
            TextSpan(
                text: titileStr,
                style: textStyle?.copyWith(fontWeight: FontWeight.w700) ??
                    defTextStyle.copyWith(fontWeight: FontWeight.w700)),
            TextSpan(text: text, style: textStyle ?? defTextStyle)
          ]),
        );
      } else {
        return Text(text,
            textAlign: textAlign ?? TextAlign.start,
            maxLines: maxlines ?? 1000,
            overflow: TextOverflow.ellipsis,
            style: textStyle ?? defTextStyle);
      }
    }
    // 如果有需要高亮显示的内容
    return _lightView(defTextStyle, defLightStyle);
  }

  /// 需要高亮显示的内容
  Widget _lightView(TextStyle defTextStyle, TextStyle defLightStyle) {
    List<TextSpan> spans = [];
    int titleStart = 0;
    int titleEnd;
    int start = 0; // 当前要截取字符串的起始位置
    int end; // end 表示要高亮显示的文本出现在当前字符串中的索引

    for (var lightText in lightTexts!) {
      if (titileStr.isNotEmpty) {
        while ((titleEnd = titileStr.indexOf(lightText, titleStart)) != -1) {
          // 第一步：添加正常显示的文本
          spans.add(TextSpan(
              text: titileStr.substring(titleStart, titleEnd),
              style: textStyle?.copyWith(fontWeight: FontWeight.w700) ??
                  defTextStyle.copyWith(fontWeight: FontWeight.w700)));
          // 第二步：添加高亮显示的文本
          spans.add(TextSpan(
              text: lightText,
              style: lightStyle?.copyWith(fontWeight: FontWeight.w700) ??
                  defLightStyle.copyWith(fontWeight: FontWeight.w700),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  if (onTapLightText != null) {
                    onTapLightText!(lightText);
                  }
                }));
          // 设置下一段要截取的开始位置
          titleStart = titleEnd + lightText.length;
        }
        spans.add(TextSpan(
            text: titileStr.substring(titleStart, titileStr.length),
            style: textStyle?.copyWith(fontWeight: FontWeight.w700) ??
                defTextStyle.copyWith(fontWeight: FontWeight.w700)));
      }
      // 如果有符合的高亮文字
      while ((end = text.indexOf(lightText, start)) != -1) {
        // 第一步：添加正常显示的文本
        spans.add(TextSpan(
            text: text.substring(start, end),
            style: textStyle ?? defTextStyle));
        // 第二步：添加高亮显示的文本
        spans.add(TextSpan(
            text: lightText,
            style: lightStyle ?? defLightStyle,
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                if (onTapLightText != null) {
                  onTapLightText!(lightText);
                }
              }));
        // 设置下一段要截取的开始位置
        start = end + lightText.length;
      }
    }

    // 下面这行代码的意思是
    // 如果没有要高亮显示的，则start=0，也就是返回了传进来的text
    // 如果有要高亮显示的，则start=最后一个高亮显示文本的索引，然后截取到text的末尾
    spans.add(
      TextSpan(
          text: text.substring(start, text.length),
          style: textStyle ?? defTextStyle),
    );

    return RichText(
      textAlign: textAlign ?? TextAlign.start,
      maxLines: maxlines ?? 1000,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(children: spans),
    );
  }
}
