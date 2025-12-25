import 'package:flutter/material.dart';
import 'package:lawyer_app/app/common/constants/app_colors.dart';
import 'package:lawyer_app/app/common/extension/widget_extension.dart';
import 'package:lawyer_app/app/utils/image_utils.dart';
import 'package:lawyer_app/app/utils/screen_utils.dart';
import 'package:lawyer_app/gen/assets.gen.dart';

import '../../controllers/new_home_page_controller.dart';

class TaskCard extends StatelessWidget {
  final NewHomePageController controller;
  const TaskCard({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 16.toW),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(14.toW),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 14,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: Container(
              width: 100.toW,
              height: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14.toW),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: 100.toW,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14.toW),
              ),
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: ImageUtils(
              imageUrl: Assets.home.yuangaoNoticeBg.path,
              width: 300.toW,
              fit: BoxFit.contain,
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: ImageUtils(
              imageUrl: Assets.home.noticeIcon.path,
              width: 30.toW,
              height: 30.toW,
            ),
          ),
          Positioned(
            top: 16.toW,
            right: 13.toW,
            child: ImageUtils(
              imageUrl: Assets.home.yuangaoIcon.path,
              width: 69.toW,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ImageUtils(
                    imageUrl: Assets.home.anjianZongs.path,
                    width: 20.toW,
                    height: 20.toW,
                  ),
                  SizedBox(width: 8.toW),
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 170.toW),
                    child: Text(
                      '缴纳诉讼费',
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 15.toSp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.color_E6000000,
                      ),
                    ),
                  ),
                  SizedBox(width: 6.toW),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 6.toW,
                      vertical: 3.toW,
                    ),
                    decoration: BoxDecoration(
                      color: Color(0xFFFDECEE),
                      borderRadius: BorderRadius.circular(4.toW),
                    ),
                    child: Text(
                      '紧急',
                      style: TextStyle(
                        fontSize: 10.toSp,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFFE34D59),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.toW),
              _infoRow('案件：', '张三诉讼李四合同纠纷案'),
              SizedBox(height: 6.toW),
              _infoRow('截止：', '2025-12-31'),
              SizedBox(height: 6.toW),
              _infoRow('承办人（法官）：', '李世斌'),
              SizedBox(height: 6.toW),
              _infoRow('电话：', '13759200942'),
              SizedBox(height: 12.toW),
              Row(
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [_avatar(true), _avatar(false), _avatar(false)],
                    ),
                  ).withExpanded(),
                  Width(30.toW),
                  _smallButton('备注'),
                ],
              ),
            ],
          ).withPaddingAll(14.toW),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 13.toSp, color: AppColors.color_66000000),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 13.toSp,
              color: AppColors.color_E6000000,
            ),
          ),
        ),
      ],
    );
  }

  Widget _avatar(bool isSender) {
    return Column(
      children: [
        Stack(
          children: [
            ImageUtils(
              imageUrl: Assets.home.defaultUserIcon.path,
              width: 32.toW,
              height: 32.toW,
              circularRadius: 16.toW,
              borderColor: Colors.white,
              borderWidth: 1,
            ),
            if (isSender)
              Positioned(
                left: 3.toW,
                right: 3.toW,
                bottom: 0,
                child: Container(
                  height: 10.toW,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.toW),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xFFFFE9CD), Color(0xFFE0AF7D)],
                    ),
                  ),
                  child: Text(
                    '发起人',
                    style: TextStyle(
                      color: Color(0xFF603619),
                      fontSize: 6.toSp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
          ],
        ),
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 32.toW),
          child: Text(
            '腰动力',
            maxLines: 1,
            style: TextStyle(color: AppColors.color_42000000, fontSize: 9.toSp),
          ),
        ),
      ],
    );
  }

  Widget _smallButton(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.toW, vertical: 5.toW),
      decoration: BoxDecoration(
        color: AppColors.color_FFEEEEEE,
        borderRadius: BorderRadius.circular(8.toW),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 14.toSp, color: AppColors.color_E6000000),
      ),
    ).withOnTap((){
      controller.addRemarkMethod();
    });
  }
}
