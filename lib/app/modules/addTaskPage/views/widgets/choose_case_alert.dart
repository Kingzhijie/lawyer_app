import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lawyer_app/app/common/constants/app_colors.dart';
import 'package:lawyer_app/app/utils/image_utils.dart';
import 'package:lawyer_app/app/utils/screen_utils.dart';
import 'package:lawyer_app/app/utils/toast_utils.dart';
import 'package:lawyer_app/gen/assets.gen.dart';

import '../../../../common/components/bottom_sheet_utils.dart';
import '../../../../common/components/easy_refresher.dart';
import '../../../../common/extension/widget_extension.dart';
import '../../../../http/apis.dart';
import '../../../../http/net/net_utils.dart';
import '../../../../http/net/tool/error_handle.dart';
import '../../../../utils/object_utils.dart';
import '../../../casePage/models/case_base_info_model.dart';
import 'add_task_item.dart';
import 'choose_concerned_person_alert.dart';

class ChooseCaseAlert extends StatefulWidget {
  final Function(CaseBaseInfoModel selectModel) chooseCaseCallBack;
  const ChooseCaseAlert({super.key, required this.chooseCaseCallBack});

  @override
  State<ChooseCaseAlert> createState() => _ChooseCaseAlertState();
}

class _ChooseCaseAlertState extends State<ChooseCaseAlert> {
  double viewTop = 114.toW;

  List<CaseBaseInfoModel> caseBaseInfoList = [];
  int pageNo = 1;
  final EasyRefreshController easyRefreshController = EasyRefreshController(
    controlFinishRefresh: true,
    controlFinishLoad: true,
  );

  CaseBaseInfoModel? selectModel;

  @override
  void initState() {
    super.initState();
    getCaseListData(true);
  }

  ///获取数据
  Future<void> getCaseListData(bool isRefresh) async {
    Map<String, dynamic> parameters = {
      'page': pageNo,
      'pageSize': 10,
      'status': null,
    };
    var result = await NetUtils.get(
      Apis.caseBasicInfoList,
      isLoading: false,
      queryParameters: parameters,
    );
    if (result.code == NetCodeHandle.success) {
      var list = (result.data['list'] as List)
          .map((e) => CaseBaseInfoModel.fromJson(e))
          .toList();
      if (isRefresh) {
        caseBaseInfoList = list;
        finishRefresh();
      } else {
        caseBaseInfoList.addAll(list);
      }
      bool isNoMore = caseBaseInfoList.length >= result.data['total'];
      delay(500, () {
        finishLoad(isNoMore);
      });
      setState(() {});
    } else {
      finishRefresh();
      finishLoad(true);
    }
  }

  void onRefresh() async {
    pageNo = 1;
    await getCaseListData(true);
  }

  void onLoadMore() async {
    pageNo += 1;
    await getCaseListData(false);
  }

  /// 下拉刷新完成
  void finishRefresh() {
    easyRefreshController.finishRefresh();
    easyRefreshController.resetFooter();
  }

  /// 上拉加载完成
  void finishLoad(bool isLast) {
    if (isLast) {
      easyRefreshController.finishLoad(IndicatorResult.noMore);
    } else {
      easyRefreshController.finishLoad();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppScreenUtil.screenHeight,
      padding: EdgeInsets.only(top: viewTop),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(12.toW)),
          color: Colors.white,
        ),
        child: Column(
          children: [
            if (viewTop == 0) SizedBox(height: AppScreenUtil.statusBarHeight),
            Container(
              height: 48.toW,
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 100.toW,
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(left: 16.toW),
                    child: Row(
                      children: [
                        Icon(
                          Icons.close,
                          color: Colors.black,
                          size: 22.toW,
                        ).withOnTap(() {
                          Navigator.pop(context);
                        }),
                        Width(10.toW),
                        if (viewTop == 0)
                          Icon(
                            Icons.close_fullscreen,
                            color: Colors.black,
                            size: 19.toW,
                          ).withOnTap(() {
                            setState(() {
                              viewTop = 114.toW;
                            });
                          })
                        else
                          ImageUtils(
                            imageUrl: Assets.common.quanpingIcon.path,
                            width: 20.toW,
                          ).withOnTap(() {
                            setState(() {
                              viewTop = 0;
                            });
                          }),
                      ],
                    ),
                  ),
                  Text(
                    '选择案件',
                    style: TextStyle(
                      color: AppColors.color_E6000000,
                      fontSize: 16.toSp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Container(
                    width: 100.toW,
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.only(right: 16.toW),
                    child: Text(
                      '确定',
                      style: TextStyle(
                        color: AppColors.theme,
                        fontSize: 16.toSp,
                      ),
                    ),
                  ).withOnTap((){
                    if (selectModel == null) {
                      showToast('请选择案件');
                      return;
                    }
                    Navigator.pop(context);
                    widget.chooseCaseCallBack(selectModel!);
                  }),
                ],
              ),
            ),
            _setFilterWidget(),
            MSEasyRefresher(
              controller: easyRefreshController,
              onRefresh: () {
                onRefresh();
              },
              onLoad: () {
                onLoadMore();
              },
              childBuilder: (context, physics) {
                return ListView.builder(
                  physics: physics,
                  itemCount: caseBaseInfoList.length,
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.toW,
                    vertical: 16.toW,
                  ),
                  itemBuilder: (context, index) {
                    CaseBaseInfoModel model = caseBaseInfoList[index];
                    return AddTaskItem(
                      type: TaskEnum.choose,
                      model: model,
                      isSelect: model.isSelect ?? false
                    ).withOnTap((){
                      caseBaseInfoList.forEach((e){
                        e.isSelect = false;
                      });
                      setState(() {
                        model.isSelect = true;
                      });
                      selectModel = model;
                    });
                  },
                );
              },
            ).withExpanded(),
          ],
        ),
      ).withOnTap(() {}),
    ).withOnTap(() {
      Get.back();
    });
  }

  Widget _setFilterWidget() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.toW, horizontal: 16.toW),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _setFilterItemWidget('当事人').withOnTap(() {
            _chooseConcernedAction();
          }),
          _setFilterItemWidget('任务类型'),
          Container(
            width: 44.toW,
            height: 44.toW,
            alignment: Alignment.center,
            child: ImageUtils(
              imageUrl: Assets.home.searchIcon.path,
              width: 22.toW,
              height: 22.toW,
            ),
          ),
        ],
      ),
    );
  }

  Widget _setFilterItemWidget(String name) {
    return Container(
      width: 140.toW,
      height: 44.toW,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.toW),
        border: Border.all(color: AppColors.color_line, width: 0.5),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.toW),
      child: Row(
        children: [
          Text(
            name,
            style: TextStyle(
              color: AppColors.color_66000000,
              fontSize: 14.toSp,
            ),
          ).withExpanded(),
          ImageUtils(
            imageUrl: Assets.common.careDownQs.path,
            width: 16.toW,
            height: 16.toW,
          ),
        ],
      ),
    );
  }

  void _chooseConcernedAction() {
    BottomSheetUtils.show(
      context,
      isShowCloseIcon: false,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.transparent,
      contentWidget: ChooseConcernedPersonAlert(),
    );
  }
}
