import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:lawyer_app/app/common/components/image_text_button.dart';
import 'package:lawyer_app/app/utils/object_utils.dart';
import 'package:lawyer_app/gen/assets.gen.dart';

import '../../../../common/constants/app_colors.dart';
import '../../../../common/extension/widget_extension.dart';
import '../../../../utils/screen_utils.dart';

///创建案件
class CreateCaseWidget extends StatefulWidget {
  const CreateCaseWidget({super.key});

  @override
  State<CreateCaseWidget> createState() => _CreateCaseWidgetState();
}

class _CreateCaseWidgetState extends State<CreateCaseWidget> {
  final TextEditingController controller = TextEditingController();

  List<String> lichangs = ['被告', '原告'];
  List<String> ajxzs = ['行政', '民事', '刑事'];
  List<String> sscxs = ['一审', '二审', '三审'];

  String? lichang;
  String? xingzhi;
  String? chengxu;

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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '创建案件',
                    style: TextStyle(
                      color: AppColors.color_E6000000,
                      fontSize: 16.toSp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Height(29.toW),
              Row(
                children: [
                  Text(
                    '*',
                    style: TextStyle(
                      color: Color(0xFFFF383C),
                      fontSize: 14.toSp,
                    ),
                  ),
                  Text(
                    ' 案件名称',
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
                child: TextField(
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
                    hintText: '请输入任务名称',
                    hintStyle: TextStyle(
                      color: AppColors.color_FFC5C5C5,
                      fontSize: 16.toSp,
                    ),
                  ),
                  onChanged: (text) {
                    setState(() {});
                  },
                  onSubmitted: (text) {},
                ),
              ),
              Text(
                '请控制在4-20个字符',
                style: TextStyle(
                  color: AppColors.color_66000000,
                  fontSize: 14.toSp,
                ),
              ).withMarginOnly(top: 8.toW),
              _setItem(lichangs, '选择立场'),
              _setItem(ajxzs, '案件性质'),
              _setItem(sscxs, '诉讼程序'),
            ],
          ),
          Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.toW),
                  gradient: LinearGradient(
                    colors: [Color(0xFF0060FF), Color(0xFF10B2F9)],
                  ),
                ),
                alignment: Alignment.center,
                height: 52.toW,
                child: Text(
                  '创建',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.toSp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
              .withOpacity(_isEnableClick() ? 1.0 : 0.5)
              .withMarginOnly(bottom: 10.toW),
        ],
      ),
    ).unfocusWhenTap();
  }

  Widget _setItem(List<String> items, String name) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: TextStyle(fontSize: 14.toSp, color: AppColors.color_E6000000),
        ),
        Height(12.toW),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: items
                .map(
                  (e) => Container(
                    width: (AppScreenUtil.screenWidth - 32.toW) / 3,
                    alignment: Alignment.centerLeft,
                    height: 25.toW,
                    child: ImageText(
                      maxWidth: (AppScreenUtil.screenWidth - 32.toW) / 3,
                      position: Position.left,
                      space: 8.toW,
                      imgUrl: _isSelect(name, e)
                          ? Assets.home.selectCrileIcon.path
                          : Assets.home.unSelectCrileIcon.path,
                      width: 24.toW,
                      height: 24.toW,
                      title: e,
                      style: TextStyle(
                        color: AppColors.color_E6000000,
                        fontSize: 16.toSp,
                      ),
                      onTap: () {
                        switch (name) {
                          case '选择立场':
                            lichang = e;
                          case '案件性质':
                            xingzhi = e;
                          case '诉讼程序':
                            chengxu = e;
                        }
                        setState(() {});
                      },
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    ).withMarginOnly(top: 20.toW);
  }

  bool _isSelect(String name, String e) {
    switch (name) {
      case '选择立场':
        return lichang == e;
      case '案件性质':
        return xingzhi == e;
      case '诉讼程序':
        return chengxu == e;
    }
    return false;
  }

  bool _isEnableClick() {
    if (controller.text.isNotEmpty &&
        !ObjectUtils.isEmptyString(lichang) &&
        !ObjectUtils.isEmptyString(xingzhi) &&
        !ObjectUtils.isEmptyString(chengxu)) {
      return true;
    }
    return false;
  }
}
