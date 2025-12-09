import 'package:flutter/material.dart';

import '../../utils/image_utils.dart';
import '../extension/widget_extension.dart';

enum Position { top, right, left, bottom, center }

class ImageText extends StatelessWidget {
  final Position position; //位置
  final String? imgUrl; //路径
  final Widget? imgWidget; //image
  final double? width; //图片宽度
  final double? height; //图片高度
  final double? space; //间距
  final String? title; //文字
  final TextStyle? style; //文字样式
  final Function? onTap; //点击事件
  final double? maxWidth; //文本最大宽度
  final double? radius; //圆角, 仅网络图片使用
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisAlignment mainAxisAlignment;
  final Color? imageBgColor;
  final Color? imageColor;

  const ImageText(
      {Key? key,
      this.position = Position.top,
      this.imageBgColor,
        this.imageColor,

      this.width,
      this.height,
      this.space,
      this.title,
      this.style,
      this.onTap,
      this.imgUrl,
      this.imgWidget,
      this.maxWidth,
      this.radius,
      this.crossAxisAlignment = CrossAxisAlignment.center,
      this.mainAxisAlignment = MainAxisAlignment.center})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return onTap != null
        ? _customItem().withOnTap(() {
            onTap!();
          })
        : _customItem();
  }

  Widget _customItem() {
    switch (position) {
      case Position.top:
        return Column(
          crossAxisAlignment: crossAxisAlignment,
          mainAxisAlignment: mainAxisAlignment,
          mainAxisSize: MainAxisSize.min,
          children: [
            _loadImage(),
            Container(
              constraints:
                  BoxConstraints(maxWidth: maxWidth ?? double.infinity),
              padding: EdgeInsets.only(top: space ?? 0),
              child: Text(
                title ?? '',
                style: style,
                maxLines: 1,
              ),
            )
          ],
        );
      case Position.bottom:
        return Column(
          crossAxisAlignment: crossAxisAlignment,
          mainAxisAlignment: mainAxisAlignment,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              constraints:
                  BoxConstraints(maxWidth: maxWidth ?? double.infinity),
              padding: EdgeInsets.only(bottom: space ?? 0),
              child: Text(title ?? '', style: style, maxLines: 1),
            ),
            _loadImage(),
          ],
        );
      case Position.left:
        return Row(
          mainAxisAlignment: mainAxisAlignment,
          crossAxisAlignment: crossAxisAlignment,
          mainAxisSize: MainAxisSize.min,
          children: [
            _loadImage(),
            Container(
              constraints:
                  BoxConstraints(maxWidth: maxWidth ?? double.infinity),
              padding: EdgeInsets.only(left: space ?? 0),
              child: Text(title ?? '', style: style, maxLines: 1),
            )
          ],
        );
      case Position.right:
        return Row(
          mainAxisAlignment: mainAxisAlignment,
          crossAxisAlignment: crossAxisAlignment,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              constraints:
                  BoxConstraints(maxWidth: maxWidth ?? double.infinity),
              padding: EdgeInsets.only(right: space ?? 0),
              child: Text(title ?? '', style: style, maxLines: 1),
            ),
            _loadImage(),
          ],
        );
      case Position.center:
        return Stack(
          alignment: AlignmentDirectional.center,
          children: [
            _loadImage(),
            Container(
              alignment: Alignment.center,
              constraints:
                  BoxConstraints(maxWidth: maxWidth ?? double.infinity),
              padding: EdgeInsets.only(right: space ?? 0),
              child: Text(title ?? '', style: style, maxLines: 1),
            )
          ],
        );
    }
  }

  Widget _loadImage() {
    if (imgWidget != null) {
      return imgWidget!;
    } else {
      return Container(
        color: imageBgColor,
        child: ImageUtils(
            imageUrl: imgUrl,
            width: width,
            height: height,
            imageColor: imageColor,
            circularRadius: radius),
      );
    }
  }
}
