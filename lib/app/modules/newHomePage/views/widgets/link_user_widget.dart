import 'package:flutter/material.dart';
import 'package:lawyer_app/app/common/constants/app_colors.dart';
import 'package:lawyer_app/app/common/extension/widget_extension.dart';
import 'package:lawyer_app/app/utils/image_utils.dart';
import 'package:lawyer_app/app/utils/screen_utils.dart';
import 'package:lawyer_app/gen/assets.gen.dart';

class LinkUserWidget extends StatefulWidget {
  const LinkUserWidget({super.key});

  @override
  State<LinkUserWidget> createState() => _LinkUserWidgetState();
}

class _LinkUserWidgetState extends State<LinkUserWidget> {
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(
        top: 13.toW,
        bottom: AppScreenUtil.bottomBarHeight + 13.toW,
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.toW),
      child: Column(
        children: [
          Text(
            '关联用户',
            style: TextStyle(
              color: AppColors.color_E6000000,
              fontSize: 16.toSp,
              fontWeight: FontWeight.w500,
            ),
          ),
          Height(29.toW),
          Row(
            children: [
              Text(
                '搜索关联用户',
                style: TextStyle(
                  color: AppColors.color_E6000000,
                  fontSize: 14.toSp,
                ),
              ),
            ],
          ),
          Height(8.toW),
          Container(
            height: 52.toW,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.color_line, width: 0.6),
              borderRadius: BorderRadius.circular(8.toW),
            ),
            padding: EdgeInsets.symmetric(horizontal: 12.toW),
            child: Row(
              children: [
                TextField(
                  textAlign: TextAlign.start,
                  maxLines: 1,
                  controller: controller,
                  style: TextStyle(
                    color: AppColors.color_E6000000,
                    fontSize: 16.toSp,
                  ),
                  // controller: _controller,
                  autofocus: true,
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    counterText: '',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                    // 移除默认内边距
                    hintText: '请输入用户的手机号码',
                    hintStyle: TextStyle(
                      color: AppColors.color_FFC5C5C5,
                      fontSize: 16.toSp,
                    ),
                  ),
                  onChanged: (text) {
                    setState(() {});
                  },
                  onSubmitted: (text) {},
                ).withExpanded(),
                Text(
                  '搜索',
                  style: TextStyle(
                    color: controller.text.isEmpty
                        ? Color(0xFF689CF1)
                        : AppColors.theme,
                    fontSize: 16.toSp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          if (controller.text != '18539921059')
            Row(
              children: [
                Text(
                  '无关联用户，请确认对方是否注册',
                  style: TextStyle(color: Color(0xFFFF383C), fontSize: 14.toSp),
                )
              ],
            ).withMarginOnly(top: 8.toW)
          else if (controller.text == '18539921059')
            ListView.builder(
              itemCount: 20,
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) {
                return _setItem();
              },
            ).withExpanded(),
        ],
      ),
    ).unfocusWhenTap();
  }

  Widget _setItem(){
    return Container(
      margin: EdgeInsets.only(top: 12.toW),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.toW),
        color: Color(0xFFF5F7FA),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 16.toW,
        vertical: 12.toW,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              ImageUtils(
                imageUrl: Assets.home.defaultUserIcon.path,
                width: 48.toW,
                height: 48.toW,
              ),
              Width(10.toW),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '韩律师',
                    style: TextStyle(
                      color: AppColors.color_E6000000,
                      fontSize: 16.toSp,
                    ),
                  ),
                  Height(4.toW),
                  Text(
                    '18539921059',
                    style: TextStyle(
                      color: AppColors.color_99000000,
                      fontSize: 14.toSp,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Container(
            width: 60.toW,
            height: 28.toW,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.toW),
              gradient: LinearGradient(
                colors: [Color(0xFF0060FF), Color(0xFF10B2F9)],
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              '关联',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.toSp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

}
