import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lawyer_app/app/common/components/easy_refresher.dart';
import 'package:lawyer_app/app/common/components/empty_content_widget.dart';
import 'package:lawyer_app/app/common/constants/app_colors.dart';
import 'package:lawyer_app/app/common/extension/widget_extension.dart';
import 'package:lawyer_app/app/modules/securityListPage/views/widgets/security_list_item.dart';
import 'package:lawyer_app/app/utils/image_utils.dart';
import 'package:lawyer_app/app/utils/screen_utils.dart';
import 'package:lawyer_app/gen/assets.gen.dart';

import '../controllers/security_list_page_controller.dart';

class SecurityListPageView extends GetView<SecurityListPageController> {
  const SecurityListPageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.color_FFF3F3F3,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // 背景
          Positioned(
            top: 0,
            right: 0,
            left: 0,
            child: ImageUtils(
              imageUrl: Assets.home.homeBg.path,
              width: AppScreenUtil.screenWidth,
            ),
          ),
          Column(
            children: [
              Container(
                height: AppScreenUtil.navigationBarHeight,
                padding: EdgeInsets.only(
                  top: AppScreenUtil.statusBarHeight,
                  left: 16.toW,
                  right: 16.toW,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 34.toW,
                      height: 34.toW,
                      child: Icon(
                        Icons.arrow_back_ios,
                        size: 24.toW,
                        color: Colors.black,
                      ),
                    ).withOnTap(() {
                      Get.back();
                    }),
                    Text(
                      '保全清单',
                      style: TextStyle(
                        fontSize: 18.toSp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.color_E6000000,
                      ),
                    ),
                    SizedBox(width: 34.toW),
                  ],
                ),
              ),
              _buildSearchBar(),
              Height(8.toW),
              _buildFilterTabs(),
              SizedBox(height: 10.toW),
              Expanded(
                child: MSEasyRefresher(
                  controller: controller.easyRefreshController,
                  onRefresh: () {
                    controller.onRefresh();
                  },
                  onLoad: () {
                    controller.onLoadMore();
                  },
                  childBuilder: (c, physics) {
                    return _buildCaseList(physics);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    ).unfocusWhenTap();
  }

  /// 搜索栏
  Widget _buildSearchBar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.toW, vertical: 8.toW),
      padding: EdgeInsets.symmetric(horizontal: 14.toW),
      height: 44.toW,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.toW),
        border: Border.all(width: 0.5, color: Color(0xFFE7E7E7)),
      ),
      child: Row(
        children: [
          ImageUtils(
            imageUrl: Assets.home.searchIcon.path,
            width: 18.toW,
            height: 18.toW,
          ),
          SizedBox(width: 8.toW),
          Expanded(
            child: TextField(
              textAlign: TextAlign.start,
              maxLines: 1,
              style: TextStyle(
                color: AppColors.color_E6000000,
                fontSize: 14.toSp,
              ),
              controller: controller.textEditingController,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                counterText: '',
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero, // 移除默认内边距
                hintText: '搜索',
                hintStyle: TextStyle(
                  color: AppColors.color_FFC5C5C5,
                  fontSize: 14.toSp,
                ),
              ),
              onChanged: (text) {},
              onSubmitted: (text) {
                controller.searchAction();
              },
            ),
          ),
        ],
      ),
    );
  }

  /// 筛选标签
  Widget _buildFilterTabs() {
    return Obx(() {
      final selectedTabIndex = controller.selectedTabIndex.value;
      final assetsTabCountModel = controller.assetsTabCountModel.value;
      final tabs = [
        '全部(${assetsTabCountModel?.totalCount ?? 0})',
        '60日到期(${assetsTabCountModel?.expiry60Count ?? 0})',
        '45日到期(${assetsTabCountModel?.expiry45Count ?? 0})',
        '30日到期(${assetsTabCountModel?.expiry30Count ?? 0})',
      ];
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16.toW),
        child: Row(
          children: List.generate(tabs.length, (index) {
            final tab = tabs[index];
            final isSelected = selectedTabIndex == index;
            return Padding(
              padding: EdgeInsets.only(right: 12.toW),
              child: GestureDetector(
                onTap: () => controller.selectTab(index),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.toW,
                    vertical: 8.toW,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.color_E6000000
                        : AppColors.color_FFF3F3F3,
                    borderRadius: BorderRadius.circular(8.toW),
                  ),
                  child: Text(
                    tab,
                    style: TextStyle(
                      fontSize: 13.toSp,
                      fontWeight: FontWeight.normal,
                      color: isSelected
                          ? AppColors.color_white
                          : AppColors.color_99000000,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      );
    });
  }

  /// 案件列表
  Widget _buildCaseList(ScrollPhysics physics) {
    return Obx(() {
      final cases = controller.securityList.value;
      if (cases.isEmpty) {
        return EmptyContentWidget(content: '暂无数据', top: 100.toW);
      }

      return ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 16.toW, vertical: 8.toW),
        itemCount: cases.length,
        shrinkWrap: true,
        physics: physics,
        itemBuilder: (context, index) {
          final item = cases[index];
          return SecurityListItem(caseInfo: item)
              .withOnTap(() {
                controller.pushDetailPage(item);
              })
              .withMarginOnly(bottom: 12.toW);
        },
      );
    });
  }
}
