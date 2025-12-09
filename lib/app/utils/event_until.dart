
import 'package:flutter/material.dart';

enum EventEnum {
  ///登录成功
  loginSuccess,
}

/// 枚举扩展
extension EventBus on EventEnum {
  /// 触发事件，事件触发后该事件所有订阅者会被调用
  void fire<T>({T? arguments}) {
    var list = _eventMap[this];
    if (list == null) {
      return;
    }
    int len = list.length - 1;

    /// 反向遍历，防止订阅者在回调中移除自身带来的下标错位
    for (var i = len; i > -1; --i) {
      EventListener<T> listener = list[i] as EventListener<T>;
      listener.handler(arguments);
    }
  }

  /// 订阅事件
  void on<T>(EventListener<T> listener) {
    _eventMap[this] ??= [];
    _eventMap[this]?.add(listener);
  }

  /// 移除事件订阅
  void off(EventListener listener) {
    _eventMap[this]?.remove(listener);
  }

  /// 移除所有事件订阅
  void offAll() {
    _eventMap[this] = null;
  }
}

/// 字符串扩展
extension EventStringBus on String {
  /// 触发事件，事件触发后该事件所有订阅者会被调用
  void fire<T>({T? arguments}) {
    var list = _eventStringMap[this];
    if (list == null) {
      return;
    }
    int len = list.length - 1;

    /// 反向遍历，防止订阅者在回调中移除自身带来的下标错位
    for (var i = len; i > -1; --i) {
      EventListener<T> listener = list[i] as EventListener<T>;
      listener.handler(arguments);
    }
  }

  /// 订阅事件
  void on<T>(EventListener<T> listener) {
    _eventStringMap[this] ??= [];
    _eventStringMap[this]?.add(listener);
  }

  /// 移除事件订阅
  void off(EventListener listener) {
    _eventStringMap[this]?.remove(listener);
  }

  /// 移除所有事件订阅
  void offAll() {
    _eventStringMap[this] = null;
  }
}

class EventListener<T> {
  EventListener(this.handler);
  final ValueChanged<T?> handler;
}

final Map<EventEnum, List<EventListener>?> _eventMap = {};
final Map<String, List<EventListener>?> _eventStringMap = {};
