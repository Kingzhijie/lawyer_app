import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lawyer_app/app/common/components/image_text_button.dart';
import 'package:lawyer_app/app/common/constants/app_colors.dart';
import 'package:lawyer_app/app/common/extension/widget_extension.dart';
import 'package:lawyer_app/app/utils/date_utils.dart';
import 'package:lawyer_app/app/utils/screen_utils.dart';
import 'package:lawyer_app/gen/assets.gen.dart';

import '../../models/case_task_model.dart';

class RemarkCaseWidget extends StatelessWidget {
  final List<Notes>? notes;
  const RemarkCaseWidget({super.key, this.notes});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          margin: EdgeInsets.only(top: 9.toW),
          decoration: BoxDecoration(
            color: Color(0xFFF5F7FA),
            borderRadius: BorderRadius.circular(8.toW),
          ),
          padding: EdgeInsets.symmetric(horizontal: 8.toW, vertical: 6.toW),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '备注:',
                    style: TextStyle(
                      color: AppColors.color_66000000,
                      fontSize: 13.toSp,
                    ),
                  ),
                  ImageText(
                    position: Position.left,
                    space: 2.toW,
                    imgUrl: Assets.home.checkCircle.path,
                    width: 16.toW,
                    height: 16.toW,
                    title: '已知',
                    style: TextStyle(
                      color: AppColors.color_66000000,
                      fontSize: 12.toSp,
                    ),
                  ),
                ],
              ),
              ListView.builder(
                itemCount: notes?.length ?? 0,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                itemBuilder: (context, index) {
                  var model = notes![index];
                  bool isHiddenLine = index == 3 - 1;
                  return Container(
                    decoration: BoxDecoration(
                      border: isHiddenLine
                          ? null
                          : Border(
                              bottom: BorderSide(
                                color: Color(0xFFE7E7E7),
                                width: 0.5,
                              ),
                            ),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 8.toW),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            text: model.createBy ?? '',
                            style: TextStyle(
                              color: AppColors.color_99000000,
                              fontSize: 10.toSp,
                              fontWeight: FontWeight.w600,
                            ),
                            children: [
                              TextSpan(
                                text: '   ${model.time}',
                                style: TextStyle(
                                  color: AppColors.color_42000000,
                                  fontSize: 10.toSp,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Height(3.toW),
                        Text(
                          model.content ?? '',
                          style: TextStyle(
                            color: AppColors.color_E6000000,
                            fontSize: 10.toSp,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        Positioned(
          top: 0,
          left: 43.toW,
          child: Transform.rotate(
            angle: pi,
            child: CustomPaint(
              painter: TrianglePainter(color: Color(0xFFF5F7FA)),
              size: Size(16.toW, 16.toW),
            ),
          ),
        ),
      ],
    ).withMarginOnly(top: 10.toW);
  }
}

/// 三角形
class TrianglePainter extends CustomPainter {
  final Color color;

  TrianglePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = color
      ..strokeJoin = StrokeJoin.round;
    var path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width / 2, size.height);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
