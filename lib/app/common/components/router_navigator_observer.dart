import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../http/net/tool/logger.dart';

final List<String> routeHistory = [];

class RouteHistoryObserver extends GetObserver {

  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    if (route.settings.name != null) {
      routeHistory.add(route.settings.name!);
    }
    logPrint('Pushed route: ${route.settings.name}');
    logPrint('Route history: $routeHistory');
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    if (route.settings.name != null) {
      routeHistory.remove(route.settings.name!);
    }
    logPrint('Popped route: ${route.settings.name}');
    logPrint('Route history: $routeHistory');
  }
}
