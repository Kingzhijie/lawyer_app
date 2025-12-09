
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../main.dart';
import '../../utils/app_common_instance.dart';
import '../../utils/object_utils.dart';
import '../../utils/screen_utils.dart';
import '../constants/app_colors.dart';
import '../extension/widget_extension.dart';


class AppDialog extends Dialog {
  /// 标题
  final String? title;

  ///标题样式
  final TextStyle? titleStyle;

  /// 内容
  final String? content;

  ///内容样式
  final TextStyle? contentStyle;

  ///第一个按钮字体样式
  final TextStyle? firstBtnTextStyle;

  ///第一个按钮字体样式
  final TextStyle? secondBtnTextStyle;

  /// 内容widget
  final Widget? contentWidget;

  /// 内容对齐方式
  final TextAlign? contentAlign;

  /// 内容内边距
  final EdgeInsetsGeometry? contentPadding;

  /// 按钮
  final List<String>? items;

  /// 点击事件 回调序列
  final ValueChanged<int>? onTap;

  /// 是否显示输入框
  final bool? showTextField;

  /// 输入框点击确认 回调输入内容
  final ValueChanged<String>? textFieldOnConfirm;

  /// 输入框占位符
  final String? textFieldHintText;

  /// 输入框最大输入
  final int? textFieldMaxLength;

  /// 输入框
  final int? textFieldMaxLines;

  /// 输入框是否可编辑
  final bool? textFieldEnabled;

  /// 点击确认是否回收,  仅输入框有效
  final bool? isOnConfirmDismiss;

  final VoidCallback? dialogDismiss;


  /// 点击背景隐藏弹框
  final bool? canClickBg;

  /// 自定义弹出框
  const AppDialog({
    Key? key,
    this.title,
    this.titleStyle,
    this.items,
    this.content,
    this.contentStyle,
    this.contentAlign = TextAlign.center,
    this.contentPadding,
    this.firstBtnTextStyle,
    this.secondBtnTextStyle,
    this.onTap,
    this.canClickBg,
    this.dialogDismiss,
  })  : showTextField = null,
        textFieldEnabled = null,
        textFieldOnConfirm = null,
        textFieldHintText = null,
        textFieldMaxLength = null,
        textFieldMaxLines = null,
        contentWidget = null,
        isOnConfirmDismiss = null,
        super(key: key);

  /// 只有单个按钮的提示弹出框
  AppDialog.singleItem({
    Key? key,
    this.title = '提示',
    this.content,
    this.titleStyle,
    this.contentStyle,
    this.contentPadding,
    this.firstBtnTextStyle,
    this.canClickBg,
    this.dialogDismiss,
    this.contentAlign = TextAlign.center,
    String cancel = '取消',
    VoidCallback? onCancel,

  })  : items = [cancel],
        onTap = ((index) {
          if (onCancel != null) {
            onCancel();
          }
        }),
        secondBtnTextStyle = null,
        showTextField = null,
        textFieldEnabled = null,
        textFieldMaxLines = null,
        textFieldOnConfirm = null,
        textFieldHintText = null,
        isOnConfirmDismiss = null,
        textFieldMaxLength = null,
        contentWidget = null,
        super(key: key);

  /// 只有两个按钮的提示弹出框
  AppDialog.doubleItem(
      {Key? key,
      this.title = '提示',
      this.content,
        this.contentWidget,
      this.titleStyle,
      this.contentStyle,
      this.contentPadding,
      this.firstBtnTextStyle,
      this.secondBtnTextStyle,
      this.canClickBg,
        this.dialogDismiss,
        this.contentAlign,
      String cancel = '取消',
      VoidCallback? onCancel,
      String confirm = '确认',
      VoidCallback? onConfirm})
      : items = [cancel, confirm],
        onTap = ((index) {
          if (index == 0) {
            if (onCancel != null) {
              onCancel();
            }
          } else {
            if (onConfirm != null) {
              onConfirm();
            }
          }
        }),
        // contentAlign = TextAlign.center,
        showTextField = null,
        textFieldEnabled = null,
        textFieldOnConfirm = null,
        textFieldHintText = null,
        textFieldMaxLength = null,
        textFieldMaxLines = null,
        isOnConfirmDismiss = null,
        super(key: key);

  /// 文本输入弹出框
  const AppDialog.textField({
    Key? key,
    this.title,
    this.titleStyle,
    this.items,
    this.dialogDismiss,
    this.contentPadding,
    ValueChanged<String>? onConfirm,
    String hintText = '请输入内容',
    int maxCount = 20,
    int maxLines = 1,
    bool enabled = true,
    bool onConfirmDismiss = true,
    this.firstBtnTextStyle,
    this.secondBtnTextStyle,
    this.canClickBg,
  })  : content = '',
        contentStyle = null,
        contentAlign = TextAlign.center,
        onTap = null,
        showTextField = true,
        textFieldOnConfirm = onConfirm,
        textFieldHintText = hintText,
        textFieldMaxLength = maxCount,
        textFieldMaxLines = maxLines,
        textFieldEnabled = enabled,
        contentWidget = null,
        isOnConfirmDismiss = onConfirmDismiss,
        super(key: key);

  /// 内容自定义widget
  AppDialog.contentCustom(
      {Key? key,
      this.title = '提示',
      this.titleStyle,
      this.contentWidget,
      this.contentPadding,
      this.firstBtnTextStyle,
      this.secondBtnTextStyle,
        this.dialogDismiss,
      this.items,
      this.canClickBg,
      VoidCallback? onCancel,
      VoidCallback? onConfirm})
      : onTap = ((index) {
          if (index == 0) {
            if (onCancel != null) {
              onCancel();
            }
          } else {
            if (onConfirm != null) {
              onConfirm();
            }
          }
        }),
        contentAlign = null,
        showTextField = null,
        textFieldEnabled = null,
        textFieldOnConfirm = null,
        textFieldHintText = null,
        textFieldMaxLength = null,
        isOnConfirmDismiss = null,
        textFieldMaxLines = null,
        content = '',
        contentStyle = null,
        super(key: key);

  /// 展示弹框
  void showAlert({BuildContext? context}) {
    if (AppInfoUtils.instance.isAlertDialog) {
      return;
    }
    AppInfoUtils.instance.isAlertDialog = true;
    showDialog(
      context: context ?? currentContext,
      builder: (context) {
        return _ShowAlertDialog(this);
      },
    ).then((value){
      if (dialogDismiss != null) {
        dialogDismiss!();
      }
      AppInfoUtils.instance.isAlertDialog = false;
    });
  }

  void dismiss({BuildContext? context}) {
    AppInfoUtils.instance.isAlertDialog = false;
    Navigator.pop(context ?? currentContext);
  }
}

class _ShowAlertDialog extends StatefulWidget {
  final AppDialog dialog;

  const _ShowAlertDialog(
    this.dialog, {
    Key? key,
  }) : super(key: key);

  @override
  _ShowAlertDialogState createState() => _ShowAlertDialogState();
}

class _ShowAlertDialogState extends State<_ShowAlertDialog> {
  TextEditingController? editController;
  FocusNode? focusNode;

  FontWeight btnTitleFontWeight = FontWeight.w600;
  bool? isEmpty = true;

  AppDialog get dialog => widget.dialog;

  @override
  void initState() {
    if (dialog.showTextField == true) {
      editController = TextEditingController(text: dialog.content!);
      editController?.addListener(() {
        isEmpty = editController?.text.trim().isEmpty;
        setState(() {});
      });
      focusNode = FocusNode();
    }
    super.initState();
  }

  @override
  void dispose() {
    focusNode?.dispose();
    editController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Center(
        // ClipRRect 创建圆角矩形 要不然发现下边button不是圆角
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12.w),
          child: Container(
            color: Colors.white,
            width: 280.w,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(height: 20.w),
                (dialog.title == null || dialog.title!.isEmpty)
                    ? Container()
                    : Container(
                  padding: dialog.contentPadding,
                  child: Text(
                    dialog.title!,
                    textAlign: TextAlign.center,
                    style: dialog.titleStyle ??
                        TextStyle(color: Colors.black, fontSize: 17.toSp, fontWeight: FontWeight.w600),
                  ),
                ),
                dialog.contentWidget ??
                    (ObjectUtils.isEmptyString(dialog.content) && !ObjectUtils.boolValue(dialog.showTextField) ? Container(
                      height: 20.toW,
                    ) : Container(
                  padding: dialog.contentPadding ??
                      EdgeInsets.only(top: 12.toW, bottom: 20.toW),
                  child: Visibility(
                    visible: dialog.contentWidget == null,
                    replacement: dialog.contentWidget == null
                        ? Container()
                        : dialog.contentWidget!,
                    child: Visibility(
                      visible: dialog.showTextField == true,
                      replacement: Container(
                        margin: EdgeInsets.symmetric(horizontal: 13.w),
                        child: Text(
                          dialog.content ?? '',
                          style: dialog.contentStyle ??
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color:
                                      Theme.of(context).colorScheme.onSurface),
                          textAlign: dialog.contentAlign,
                        ),
                      ),
                      child: Container(
                        margin: EdgeInsets.only(left: 23.w, right: 23.w),
                        padding: EdgeInsets.only(
                            left: 16.w, right: 16.w, top: 12.w, bottom: 12.w),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.black12,
                                width: 0.5),
                            borderRadius: BorderRadius.circular(5.toR)),
                        child: TextField(
                          enableInteractiveSelection: true,
                          enabled: dialog.textFieldEnabled,
                          focusNode: focusNode,
                          cursorWidth: 1,
                          cursorColor: Colors.black38,
                          maxLines: dialog.textFieldMaxLines,
                          controller: editController,
                          keyboardType: TextInputType.text,
                          inputFormatters: <TextInputFormatter>[
                            LengthLimitingTextInputFormatter(
                                dialog.textFieldMaxLength)
                          ],
                          style: TextStyle(color: Colors.black, fontSize: 14.toSp),
                          decoration: InputDecoration.collapsed(
                            filled: true,
                            fillColor: Colors.white,
                            hintText: dialog.textFieldHintText,
                            hintStyle: TextStyle(color: Colors.grey, fontSize: 14.toSp),
                          ),
                          onChanged: (value) {},
                          onSubmitted: (value){
                            if (editController?.text.trim().isNotEmpty == true) {
                              if (dialog.isOnConfirmDismiss == true) {
                                Navigator.pop(context);
                              }
                              dialog.textFieldOnConfirm
                                  ?.call((editController?.text.trim() ?? ''));
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                )),
                Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: AppColors.color_FFEDEDED,
                        width: 0.5,
                      ),
                    ),
                  ),
                ),
                _itemsCreate(),
              ],
            ),
          ),
        ),
      ),
    ).withOnTap(() {
      if ((dialog.canClickBg ?? false) == true) {
        Navigator.pop(context);
      } else {
        return;
      }
    });
  }

  Widget _itemsCreate() {
    if (dialog.items == null) {
      return Container();
    }
    return Row(
      children: dialog.items!.map((res) {
        int index = dialog.items!.indexOf(res);
        return Expanded(
          flex: 1,
          child: GestureDetector(
            onTap: () {
              if (dialog.showTextField == true) {
                focusNode?.unfocus();
                if (index == 0) {
                  Navigator.pop(context);
                  return;
                }
                if (editController?.text.trim().isNotEmpty == true) {
                  if (dialog.isOnConfirmDismiss == true) {
                    Navigator.pop(context);
                  }
                  dialog.textFieldOnConfirm
                      ?.call((editController?.text.trim() ?? ''));
                }
              } else {
                Navigator.pop(context);
                if (dialog.onTap != null) {
                  dialog.onTap!(index);
                }
              }
            },
            child: Container(
              height: 44.w,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border(
                  right: BorderSide(
                    color: AppColors.color_FFEDEDED,
                    width: 0.5,
                  ),
                ),
              ),
              child: Text(
                res,
                style: index == 0
                    ? dialog.firstBtnTextStyle ?? TextStyle(color: Colors.grey, fontSize: 14.toSp)
                    : dialog.secondBtnTextStyle ?? TextStyle(color: Colors.blue, fontSize: 14.toSp, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
