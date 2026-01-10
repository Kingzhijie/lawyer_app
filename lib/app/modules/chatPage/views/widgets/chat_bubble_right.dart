import 'package:flutter/material.dart';
import 'package:lawyer_app/app/common/constants/app_colors.dart';
import 'package:lawyer_app/main.dart';

import '../../../../../gen/assets.gen.dart';
import '../../../../common/extension/widget_extension.dart';
import '../../../../utils/file_preview_util.dart';
import '../../../../utils/image_utils.dart';
import '../../../../utils/image_viewer_util.dart';
import '../../../../utils/object_utils.dart';
import '../../../../utils/screen_utils.dart';
import '../../controllers/chat_page_controller.dart';
import '../../models/ui_message.dart';

class ChatBubbleRight extends StatelessWidget {
  const ChatBubbleRight({super.key, required this.message});

  final UiMessage message;

  @override
  Widget build(BuildContext context) {
    const bubbleColor = Colors.white;
    final textColor = AppColors.color_E6000000;
    const radius = BorderRadius.only(
      topLeft: Radius.circular(12),
      topRight: Radius.circular(12),
      bottomLeft: Radius.circular(12),
      bottomRight: Radius.circular(2),
    );

    return Align(
      alignment: Alignment.centerRight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!ObjectUtils.isEmptyList(message.images)) _setImageWidget(),
          if (!ObjectUtils.isEmptyList(message.files)) _setFilesWidget(),
          if (!ObjectUtils.isEmptyString(message.text))
            Container(
              // margin: const EdgeInsets.symmetric(vertical: 6),
              margin: EdgeInsets.only(top: 6.toW, bottom: 16.toW, left: 30.toW),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: bubbleColor,
                borderRadius: radius,
                boxShadow: [
                  BoxShadow(
                    color: Color(0x1A000000),
                    blurRadius: 14,
                    offset: const Offset(0, 0),
                  ),
                ],
              ),
              child: Text(
                message.text,
                style: TextStyle(color: textColor, fontSize: 15),
              ),
            ),
        ],
      ),
    );
  }

  ///设置文件
  Widget _setFilesWidget() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: message.files!
            .map(
              (e) =>
                  Container(
                        width: 120.toW,
                        height: 80.toW,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6.toW),
                          border: Border.all(
                            color: AppColors.color_line,
                            width: 0.5,
                          ),
                          color: Colors.white,
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 8.toW),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              (e.name ?? '').replaceAll('.${e.type}', ''),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: AppColors.color_E6000000,
                                fontSize: 13.toSp,
                              ),
                            ),
                            Height(2.toW),
                            Row(
                              children: [
                                ImageUtils(
                                  imageUrl: Assets.common.actionFileIcon.path,
                                  width: 16.toW,
                                ),
                                Text(
                                  e.type ?? '.pdf',
                                  style: TextStyle(
                                    color: AppColors.color_E6000000,
                                    fontSize: 12.toSp,
                                  ),
                                ).withExpanded(),
                              ],
                            ),
                          ],
                        ),
                      )
                      .withOnTap(() {
                        FilePreviewUtil.previewFile(
                          filePath: e.path ?? (e.url ?? ''),
                        );
                      })
                      .withMarginOnly(left: 6.toW),
            )
            .toList(),
      ),
    ).withMargin(EdgeInsets.symmetric(vertical: 6));
  }

  Widget _setImageWidget() {
    List<String> imgs = [];
    for (var e in message.images!) {
      imgs.add(e.url ?? (e.path ?? ''));
    }
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: imgs
            .map(
              (e) =>
                  Hero(
                    tag: 'chat_right_image_$e',
                    child: ImageUtils(
                      imageUrl: e,
                      width: 80.toW,
                      height: 80.toW,
                      circularRadius: 6.toW,
                    ),
                  ).withMarginOnly(left: 4.toW).withOnTap(() {
                    // 点击图片打开全屏浏览，支持多图滑动
                    ImageViewerUtil.showImageGallery(
                      currentContext,
                      imgs,
                      initialIndex: imgs.indexOf(e),
                      heroTag: 'chat_right_image_$e',
                    );
                  }),
            )
            .toList(),
      ),
    ).withMargin(EdgeInsets.symmetric(vertical: 6));
  }
}
