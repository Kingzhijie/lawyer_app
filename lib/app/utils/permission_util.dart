/// @Date: 2022-02-09
/// @Description: 权限检测工具类

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../main.dart';
import '../common/components/dialog.dart';
import '../common/constants/enum/app_enum.dart';
import 'app_common_instance.dart';
import 'device_info_utils.dart';
import 'package:flutter/foundation.dart';
import 'screen_utils.dart';

class PermissionUtils {
  static Future<bool> _requestPermission(Permission permission,
      {required String content,
      bool isToast = true,
      VoidCallback? onCancel}) async {
    var status = await permission.status;
    if (status.isDenied) {
      if ((permission == Permission.photos ||
              permission == Permission.videos) &&
          Platform.isAndroid) {
        ///安卓13以上, 需要同时申请, 相册和视频权限
        var statusList = await [
          Permission.photos,
          Permission.videos,
        ].request();
      } else if (permission == Permission.bluetoothScan &&
          Platform.isAndroid) {
        ///安卓12以上, 需要同时申请
        var statusList = await [
          Permission.bluetoothScan,
          Permission.bluetoothConnect,
          Permission.locationWhenInUse
        ].request();
      } else if (permission == Permission.bluetooth &&
          Platform.isAndroid) {
        ///安卓12以下, 默认允许
        var statusList = await [
          Permission.bluetooth,
          Permission.locationWhenInUse
        ].request();
      } else {
        status = await permission.request();
        if (status.isDenied &&
            Platform.isAndroid &&
            permission == Permission.notification &&
            AppInfoUtils.instance.appChannel == AppChannel.oppo.channel) {
          //安卓端, oppo会有问题, 需要引导用户自己去开通
          Navigator.pop(currentContext);
          showOppoPermissionGuide();
          return false;
        }
      }
      if (Platform.isAndroid) {
        Navigator.pop(currentContext);
        return status.isGranted;
      }
    } else if ((status.isDenied || status.isPermanentlyDenied)) {
      if(isToast) {
        AppDialog.doubleItem(
            title: '权限提醒',
            content: content,
            confirm: '前往设置',
            onCancel: onCancel,
            contentAlign: TextAlign.center,
            onConfirm: () {
              openAppSettings();
            }).showAlert();
      }
      return false;
    }
    if (status.isDenied || status.isPermanentlyDenied) {
      return false;
    }
    return true;
  }

  static String hintText(String text) => '请在设置中允许$text权限';


  /// 申请相册读取权限
  static Future<bool> requestPhotoPickPermission() async {
    if (Platform.isAndroid) {
      Permission permission = Permission.storage;
      String deviceSystemVersion = DeviceInfo.deviceSystemVersion ?? '';
      if (deviceSystemVersion.compareTo('13') >= 0) {
        permission = Permission.photos;
      }
      var status = await permission.status;
      if (status.isDenied) {
        showDialog(
          context: currentContext,
          builder: (context) {
            return PermissionNoticeContentWidget(
                content: '当您使用APP时，会在更换头像、意见反馈等功能时，访问相册权限，不授权上述权限，不影响APP的其他功能使用');
          },
        );
      }
      return _requestPermission(permission,
          content: '需要使用相册，选取图片, 完成头像更换或意见反馈等功能');
    }
    return _requestPermission(Permission.photos,
        content: '需要使用相册，选取图片, 完成头像更换或意见反馈等功能');
  }

  /// 申请相机权限
  static Future<bool> requestCameraPermission(
      {bool isToast = true, VoidCallback? onCancel}) async {
    if (Platform.isAndroid) {
      Permission permission = Permission.camera;
      var status = await permission.status;
      if (status.isDenied) {
        showDialog(
          context: currentContext,
          builder: (context) {
            return PermissionNoticeContentWidget(
                content: '当您使用APP时，会在更换头像、意见反馈等功能时，访问相机权限，不授权上述权限，不影响APP的其他功能使用');
          },
        );
      }
    }
    return _requestPermission(Permission.camera,
        content: '需要使用相机，拍摄图片, 完成头像更换或意见反馈等功能',
        onCancel: onCancel);
  }

  /// 申请麦克风
  static Future<bool> requestMicrophonePermission(
      {bool isToast = true, VoidCallback? onCancel}) async {
    if (Platform.isAndroid) {
      Permission permission = Permission.microphone;
      var status = await permission.status;
      if (status.isDenied) {
        showDialog(
          context: currentContext,
          builder: (context) {
            return PermissionNoticeContentWidget(
                content: '当您使用APP时，会在您发送语音消息等功能时，访问麦克风权限，不授权上述权限，不影响APP的其他功能使用');
          },
        );
      }
    }
    return _requestPermission(Permission.microphone,
        content: '需要使用麦克风权限, 实现发送语音消息等功能',
        onCancel: onCancel);
  }

  /// 申请语音转文字功能
  static Future<bool> requestSpeechPermission(
      {bool isToast = true, VoidCallback? onCancel}) async {
    if (Platform.isAndroid) {
      Permission permission = Permission.speech;
      var status = await permission.status;
      if (status.isDenied) {
        showDialog(
          context: currentContext,
          builder: (context) {
            return PermissionNoticeContentWidget(
                content: '当您使用APP时，会在您发送语音消息等功能时，访问麦克风实现语音转文字权限，不授权上述权限，不影响APP的其他功能使用');
          },
        );
      }
    }
    return _requestPermission(Permission.speech,
        content: '需要使用麦克风, 实现发送语音转文字消息等功能',
        onCancel: onCancel);
  }

  /// 申请蓝牙权限
  static Future<bool> requestBluetoothPermission(
      {bool isToast = true, VoidCallback? onCancel}) async {
    if (Platform.isAndroid) {
      String deviceSystemVersion = DeviceInfo.deviceSystemVersion ?? '';
      Permission permission = Permission.bluetooth;
      var status = await Permission.bluetooth.status;
      if (deviceSystemVersion.compareTo('12') >= 0) {   //Android 12+
        status = await Permission.bluetoothScan.status;
        permission = Permission.bluetoothScan;
      } else { //低版本默认开启蓝牙,权限, 此时只需要位置权限就可以
        if(status.isGranted) {
          return PermissionUtils.requestLocationPermissions(isToast: isToast, onCancel: onCancel);
        }
      }
      if (status.isDenied) {
        showDialog(
          context: currentContext,
          builder: (context) {
            return PermissionNoticeContentWidget(
                content: '当您使用APP时，需要使用蓝牙权限，扫描连接您的智能腰靠设备, 同时为了实现扫描附近的蓝牙设备，需要获取位置权限。不授权上述权限，不影响APP的其他功能使用');
          },
        );
      }
      return _requestPermission(permission,
          content: '需要使用蓝牙权限，扫描连接智能腰靠设备',
          onCancel: onCancel);
    }
    return _requestPermission(Permission.bluetooth,
        content: '需要使用蓝牙权限，扫描连接智能腰靠设备',
        onCancel: onCancel);
  }

  /// 申请定位权限
  static Future<bool> requestLocationPermissions(
      {bool isToast = true, VoidCallback? onCancel}) async {
    if (Platform.isAndroid) {
      Permission permission = Permission.location;
      var status = await permission.status;
      if (status.isDenied) {
        showDialog(
          context: currentContext,
          builder: (context) {
            return PermissionNoticeContentWidget(
                content: '当您使用APP时，需要使用您的位置权限，才能使用蓝牙扫描附近的设备。不授权上述权限，不影响APP的其他功能使用');
          },
        );
      }
    }
    return _requestPermission(Permission.location,
        content: '需要使用您的位置权限，才能使用蓝牙扫描附近的设备',
        onCancel: onCancel,
        isToast: isToast);
  }


  /// 安卓申请推送权限
  static Future<bool> requestNotificationPermission(
      {bool isToast = true}) async {
    if (Platform.isAndroid) {
      Permission permission = Permission.notification;
      var status = await permission.status;
      if (status.isDenied) {
        showDialog(
          context: currentContext,
          builder: (context) {
            return PermissionNoticeContentWidget(
                content: '当您使用APP时，会在产品活动, 版本更新提醒, 腰部健康数据更新时提供推送消息服务，不授权上述权限，不影响APP的其他功能使用');
          },
        );
      }
    }
    return _requestPermission(Permission.notification,
        content: '请前往设置授权推送权限',
        isToast: isToast);
  }

  static openAppSettingsPage() {
    openAppSettings();
  }

  ///展示oppo权限引导
  static void showOppoPermissionGuide() {
    AppDialog.doubleItem(
        title: '请在设置中开启通知权限',
        titleStyle: TextStyle(
            color: Colors.black,
            fontSize: 17.toSp,
            fontWeight: FontWeight.w600),
        content: '设备需要手动开启通知权限：\n1. 设置 → 通知管理 → 允许通知\n2. 设置 → 电池 → 关闭省电模式',
        contentStyle: TextStyle(color: Colors.black, fontSize: 15.toSp),
        cancel: '取消',
        confirm: '确认',
        onConfirm: () {
          openAppSettings();
        }).showAlert();
  }


}

class PermissionNoticeContentWidget extends StatelessWidget {
  final String content;

  const PermissionNoticeContentWidget({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10.toW)),
          margin: EdgeInsets.only(
              left: 25.toW,
              right: 25.toW,
              top: AppScreenUtil.navigationBarHeight),
          padding: EdgeInsets.only(
              left: 12.toW, right: 12.toW, top: 15.toW, bottom: 15.toW),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '权限使用说明',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 15.toSp,
                    fontWeight: FontWeight.w600),
              ),
              Height(15.toW),
              Text(
                content,
                style: TextStyle(color: Colors.black, fontSize: 13.toSp),
              ),
            ],
          ),
        )
      ],
    );
  }


}
