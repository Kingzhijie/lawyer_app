import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lawyer_app/app/common/constants/app_colors.dart';
import 'package:lawyer_app/app/common/extension/widget_extension.dart';
import 'package:lawyer_app/app/utils/image_utils.dart';
import 'package:lawyer_app/app/utils/screen_utils.dart';
import 'package:lawyer_app/app/utils/toast_utils.dart';
import 'package:lawyer_app/gen/assets.gen.dart';

import '../../../../http/apis.dart';
import '../../../../http/net/net_utils.dart';
import '../../../../http/net/tool/error_handle.dart';
import '../../../../routes/app_pages.dart';
import '../../../casePage/models/case_base_info_model.dart';

class NoFindCaseWidget extends StatefulWidget {
  final Function() closeWidget;
  const NoFindCaseWidget({super.key, required this.closeWidget});

  @override
  State<NoFindCaseWidget> createState() => _NoFindCaseWidgetState();
}

class _NoFindCaseWidgetState extends State<NoFindCaseWidget> {
  num? selectedId;
  final TextEditingController searchController = TextEditingController();

  List<CaseBaseInfoModel> caseWaitingList = [];
  List<CaseBaseInfoModel> caseingList = [];
  List<CaseBaseInfoModel> searchList = [];

  @override
  void initState() {
    super.initState();
    getCaseListData(0);
    getCaseListData(1);
  }

  //http://101.37.88.57/app-api/legal/task/page?page=1&pageSize=10&title=%E7%9C%8B%E7%9C%8B&partyRole=2

  ///获取数据
  Future<void> getCaseListData(int status) async {
    Map<String, dynamic> parameters = {
      'page': 1,
      'pageSize': 3,
      'status': status, //0-待更新 1-进行中 2-已归档, null: 全部
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
      if (status==0) {
        caseWaitingList = list;
      } else {
        caseingList = list;
      }
      setState(() {});
    }
  }

  ///搜索
  Future<void> searchCaseList() async {
    Map<String, dynamic> parameters = {
      'page': 1,
      'pageSize': 3,
      'caseSearch': searchController.text,
    };
    var result = await NetUtils.get(
      Apis.searchCaseInfoList,
      isLoading: false,
      queryParameters: parameters,
    );
    if (result.code == NetCodeHandle.success) {
      var list = (result.data['list'] as List)
          .map((e) => CaseBaseInfoModel.fromJson(e))
          .toList();
      searchList = list;
      if (list.isEmpty) {
        showToast('未查询到案件');
      }
      setState(() {});
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          constraints: BoxConstraints(
              minHeight: 490.toW
          ),
          padding: EdgeInsets.only(top: 40.toW, left: 15.toW, right: 15.toW),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 顶部提示文字
                  Text(
                    '未查询到案件相关信息，请选择需要更新的案件：',
                    style: TextStyle(
                      fontSize: 18.toSp,
                      color: AppColors.color_E6000000,
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: 12.toW),
                  // 搜索框
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.toW, vertical: 12.toW),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.toW),
                      border: Border.all(color: Color(0xFFEEEEEE), width: 0.5),
                    ),
                    child: Row(
                      children: [
                        ImageUtils(
                          imageUrl: Assets.home.searchIcon.path,
                          width: 15.toW,
                        ),
                        SizedBox(width: 8.toW),
                        Expanded(
                          child: TextField(
                            controller: searchController,
                            decoration: InputDecoration(
                              hintText: '请输入案件信息',
                              hintStyle: TextStyle(
                                fontSize: 14.toSp,
                                color: AppColors.color_66000000,
                              ),
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                            ),
                            onChanged: (text){
                              if (searchController.text.isEmpty) {
                                setState(() {});
                              }
                            },
                            onSubmitted: (text){
                              searchCaseList();
                            },
                            style: TextStyle(
                              fontSize: 14.toSp,
                              color: AppColors.color_E6000000,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 12.toW),
                  if (searchList.isNotEmpty && searchController.text.isNotEmpty)
                    _setStatusWidget('搜索结果', searchList)
                  else
                    ...[
                      // 待更新列表
                      _setStatusWidget('待更新', caseWaitingList),
                      _setStatusWidget('进行中', caseingList),
                    ],
                ],
              ),
              // 确认按钮
              Container(
                width: double.infinity,
                height: 52.toW,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.toW),
                    gradient: LinearGradient(colors: [
                      Color(0xFF0060FF), Color(0xFF10B2F9)
                    ])
                ),
                alignment: Alignment.center,
                child: Text(
                  '确认',
                  style: TextStyle(
                    fontSize: 16.toSp,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ).withOnTap((){
                if (selectedId != null) {
                  Get.toNamed(Routes.CASE_DETAIL_PAGE, arguments: {'caseId': selectedId});
                }
              }),
            ],
          ),
        ),
        Positioned(
            top: 0, right: 15.toW,
            child: Icon(Icons.close, size: 25.toW, color: AppColors.color_66000000).withOnTap((){
              widget.closeWidget();
            }))

      ],
    );
  }

  Widget _setStatusWidget(String name, List<CaseBaseInfoModel> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: TextStyle(fontSize: 14.toSp, color: AppColors.color_99000000),
        ),
        SizedBox(height: 6.toW),
        ListView.builder(
          itemCount: items.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            itemBuilder: (context, index) {
          return _buildCaseItem(items[index], index, false);
        })
      ],
    );
  }

  Widget _buildCaseItem(CaseBaseInfoModel model, int index, bool isOngoing) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedId = model.id;
        });
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 8.toW),
        padding: EdgeInsets.symmetric(horizontal: 8.toW, vertical: 6.toW),
        decoration: BoxDecoration(
          color: Color(0xFFF5F7FA),
          borderRadius: BorderRadius.circular(12.toW),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ImageUtils(
              imageUrl: selectedId == model.id
                  ? Assets.home.selectCrileIcon.path
                  : Assets.home.unSelectCrileIcon.path,
              width: 20.toW,
            ),
            SizedBox(width: 6.toW),
            // 案件标题
            Text(
              model.caseName ?? '',
              style: TextStyle(fontSize: 14.toSp, color: Colors.black),
            ).withExpanded(),
          ],
        ),
      ),
    );
  }
}
