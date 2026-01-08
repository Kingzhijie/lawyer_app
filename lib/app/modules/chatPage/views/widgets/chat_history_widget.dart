import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:lawyer_app/app/config/app_config.dart';
import 'package:lawyer_app/app/http/apis.dart';
import 'package:lawyer_app/app/http/net/net_utils.dart';
import 'package:lawyer_app/app/http/net/tool/error_handle.dart';
import 'package:lawyer_app/app/http/net/tool/logger.dart';
import 'package:lawyer_app/app/utils/date_utils.dart';

import '../../../../common/constants/app_colors.dart';
import '../../../../common/extension/widget_extension.dart';
import '../../../../utils/screen_utils.dart';
import '../../models/chat_history_list.dart';

class ChatHistoryWidget extends StatefulWidget {
  final Function(String id)? chooseHistoryCallBack;
  final Function()? newChatCallBack;
  final String? sessionId;
  final String? agentId;

  const ChatHistoryWidget({
    super.key,
    this.chooseHistoryCallBack,
    this.newChatCallBack,
    this.sessionId,
    this.agentId,
  });

  @override
  State<ChatHistoryWidget> createState() => _ChatHistoryWidgetState();
}

class _ChatHistoryWidgetState extends State<ChatHistoryWidget> {
  List<ChatHistoryList> listModels = [];

  @override
  void initState() {
    super.initState();
    _loadSessions();
  }

  Future<void> _loadSessions() async {
    if (widget.agentId != null) {
      listModels.clear();
      NetUtils.get(
        Apis.getAiHistoryList,
        queryParameters: {
          'agentId': widget.agentId,
          'pageNo': 1,
          'pageSize': 10,
        },
      ).then((result) {
        if (result.code == NetCodeHandle.success) {
          var list = (result.data['list'] as List)
              .map((e) => ChatHistoryList.fromJson(e))
              .toList();
          listModels += list;
          setState(() {});
        }
      });
    }
  }

  Future<void> _deleteSession(String sessionId) async {}


  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(top: AppScreenUtil.statusBarHeight),
      alignment: Alignment.center,
      child: Column(
        children: [
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.symmetric(horizontal: 15.toW),
            margin: EdgeInsets.only(top: 20.toW),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '灵半AI',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 17.toSp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '您身边的法律专家',
                  style: TextStyle(
                    color: AppColors.color_99000000,
                    fontSize: 13.toSp,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.toW),
                    border: Border.all(
                      color: AppColors.color_42000000,
                      width: 0.5,
                    ),
                  ),
                  margin: EdgeInsets.symmetric(vertical: 15.toW),
                  height: 46.toW,
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_rounded,
                        color: AppColors.color_E6000000,
                        size: 18.toW,
                      ),
                      Text(
                        '新建对话',
                        style: TextStyle(
                          color: AppColors.color_E6000000,
                          fontSize: 15.toSp,
                        ),
                      ),
                    ],
                  ),
                ).withOnTap(() {
                  if (widget.newChatCallBack != null) {
                    widget.newChatCallBack!();
                  }
                }),
                Divider(color: AppColors.color_FFF8F8F8, height: 0.5),
                Text(
                  '历史对话',
                  style: TextStyle(
                    color: AppColors.color_66000000,
                    fontSize: 14.toSp,
                  ),
                ).withMarginOnly(top: 12.toW, bottom: 12.toW),
              ],
            ),
          ),
          ListView.builder(
            itemCount: listModels.length,
            padding: EdgeInsets.only(bottom: 15.toW),
            itemBuilder: (context, index) {
              var model = listModels[index];
              return Slidable(
                key: ValueKey('${model.id}'),
                endActionPane: ActionPane(
                  motion: const ScrollMotion(),
                  extentRatio: 0.25,
                  children: [
                    SlidableAction(
                      onPressed: (_) => _deleteSession('${model.id}'),
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      icon: Icons.delete,
                      label: '删除',
                    ),
                  ],
                ),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: AppColors.color_line,
                        width: 0.5,
                      ),
                    ),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 14.toW,
                    vertical: 12.toW,
                  ),
                  child:
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  model.subject ?? '',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: AppColors.color_E6000000,
                                    fontSize: 15.toSp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Height(4.toW),
                                if (model.createTime != null)
                                  Text(
                                    DateFormatUtils.getNotificationTimeStr(
                                      model.createTime!.toInt(),
                                    ),
                                    style: TextStyle(
                                      color: AppColors.color_42000000,
                                      fontSize: 12.toSp,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          if (model.id != null &&
                              widget.sessionId == model.id.toString()) ...[
                            Width(12.toW),
                            Text(
                              '当前对话',
                              style: TextStyle(
                                color: AppColors.theme,
                                fontSize: 13.toSp,
                              ),
                            ),
                          ],
                        ],
                      ).withOnTap(() {
                        if (widget.chooseHistoryCallBack != null) {
                          widget.chooseHistoryCallBack!(model.id.toString());
                        }
                      }),
                ),
              );
            },
          ).withExpanded(),
        ],
      ),
    );
  }
}
