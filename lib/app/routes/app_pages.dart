import 'package:get/get.dart';

import '../modules/agencyPage/bindings/agency_page_binding.dart';
import '../modules/agencyPage/views/agency_page_view.dart';
import '../modules/casePage/bindings/case_page_binding.dart';
import '../modules/casePage/views/case_page_view.dart';
import '../modules/chatPage/bindings/chat_page_binding.dart';
import '../modules/chatPage/views/chat_page_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/loginCodePage/bindings/login_code_page_binding.dart';
import '../modules/loginCodePage/views/login_code_page_view.dart';
import '../modules/loginPage/bindings/login_page_binding.dart';
import '../modules/loginPage/views/login_page_view.dart';
import '../modules/newHomePage/bindings/new_home_page_binding.dart';
import '../modules/newHomePage/views/new_home_page_view.dart';
import '../modules/tabPage/bindings/tab_page_binding.dart';
import '../modules/tabPage/views/tab_page_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.TAB_PAGE;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.TAB_PAGE,
      page: () => const TabPageView(),
      binding: TabPageBinding(),
    ),
    GetPage(
      name: _Paths.CHAT_PAGE,
      page: () => const ChatPageView(),
      binding: ChatPageBinding(),
    ),
    GetPage(
      name: _Paths.AGENCY_PAGE,
      page: () => const AgencyPageView(),
      binding: AgencyPageBinding(),
    ),
    GetPage(
      name: _Paths.CASE_PAGE,
      page: () => const CasePageView(),
      binding: CasePageBinding(),
    ),
    GetPage(
      name: _Paths.NEW_HOME_PAGE,
      page: () => const NewHomePageView(),
      binding: NewHomePageBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN_PAGE,
      page: () => const LoginPageView(),
      binding: LoginPageBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN_CODE_PAGE,
      page: () => const LoginCodePageView(),
      binding: LoginCodePageBinding(),
    ),
  ];
}
