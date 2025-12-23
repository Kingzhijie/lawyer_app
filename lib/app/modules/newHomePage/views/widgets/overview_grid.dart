import 'package:flutter/material.dart';
import 'package:lawyer_app/app/common/constants/app_colors.dart';
import 'package:lawyer_app/app/utils/image_utils.dart';
import 'package:lawyer_app/app/utils/screen_utils.dart';
import 'package:lawyer_app/gen/assets.gen.dart';

class OverviewGrid extends StatelessWidget {
  const OverviewGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final cards = [
      _OverviewCardData('案件总数', '5', Assets.home.anjianZongs.path,
          const Color(0xFFECF2FE)),
      _OverviewCardData('待办任务', '17', Assets.home.dbrwIcon.path,
          AppColors.color_FFFEF3E6),
      _OverviewCardData('紧急任务', '6', Assets.home.jjrwIcon.path,
          AppColors.color_FFFDECEE),
      _OverviewCardData('非紧急任务', '11', Assets.home.fjjrwIcon.path,
          AppColors.color_FFE8F7F2),
      _OverviewCardData('保全清单', '8', Assets.home.bqqdIcon.path,
          const Color(0xFFEBEBF8)),
      _OverviewCardData('异常', '3', Assets.home.yichangIcon.path,
          AppColors.color_FFFFEDEF),
    ];

    final double cardWidth =
        (AppScreenUtil.screenWidth - 16.toW * 2 - 10.toW) / 2;

    return Wrap(
      spacing: 10.toW,
      runSpacing: 10.toW,
      children: cards
          .map((c) => _OverviewCard(
                data: c,
                width: cardWidth,
              ))
          .toList(),
    );
  }
}

class _OverviewCardData {
  final String title;
  final String value;
  final String icon;
  final Color bg;
  _OverviewCardData(this.title, this.value, this.icon, this.bg);
}

class _OverviewCard extends StatelessWidget {
  final _OverviewCardData data;
  final double width;
  const _OverviewCard({required this.data, required this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: EdgeInsets.only(
        left: 16.toW,
        right: 11.toW,
        bottom: 6.toW,
        top: 12.toW,
      ),
      decoration: BoxDecoration(
        color: data.bg,
        borderRadius: BorderRadius.circular(12.toW),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                data.title,
                style: TextStyle(
                  fontSize: 14.toSp,
                  color: AppColors.color_99000000,
                ),
              ),
              Width(4.toW),
              Icon(
                Icons.arrow_forward_ios,
                size: 13.toW,
                color: AppColors.color_FFC5C5C5,
              )
            ],
          ),
          SizedBox(height: 12.toW),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                data.value,
                style: TextStyle(
                  fontSize: 20.toSp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.color_FF1F2937,
                ),
              ),
              ImageUtils(
                imageUrl: data.icon,
                width: 30.toW,
              ),
            ],
          )
        ],
      ),
    );
  }
}

