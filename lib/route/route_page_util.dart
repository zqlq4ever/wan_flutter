import 'package:get/get.dart';
import 'package:wan_android_flutter/pages/about/about_us_viewmodel.dart';
import 'package:wan_android_flutter/pages/search/search_viewmodel.dart';
import 'package:wan_android_flutter/pages/settings/settings_viewmodel.dart';

import '../pages/about/about_us_page.dart';
import '../pages/settings/settings_page.dart';
import '../pages/auth/login/login_page.dart';
import '../pages/auth/login/login_viewmodel.dart';
import '../pages/auth/register/register_page.dart';
import '../pages/auth/register/register_viewmodel.dart';
import '../pages/knowledge/details/KnowledgeDetailsPage.dart';
import '../pages/collection/collection_page.dart';
import '../pages/collection/collection_viewmodel.dart';
import '../pages/scan/scan_page.dart';
import '../pages/search/search_page.dart';
import '../pages/home_bottom_tab.dart';
import '../pages/web/webview_page.dart';
import '../pages/web/webview_widget.dart';
import 'route_path_constant.dart';

class RoutePageUtil {
  static List<GetPage> pages = [
    GetPage(
      name: RoutePath.login,
      page: () => const LoginPage(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => LoginViewModel());
      }),
    ),
    GetPage(name: RoutePath.tab, page: () => const HomeBottomTab()),
    GetPage(
        name: RoutePath.knowledgeDetails,
        page: () => const KnowledgeDetailsPage()),
    GetPage(
      name: RoutePath.register,
      page: () => const RegisterPage(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => RegisterViewModel());
      }),
    ),
    GetPage(
      name: RoutePath.myCollection,
      page: () => const CollectionPage(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => CollectionViewModel());
      }),
    ),
    GetPage(
      name: RoutePath.webviewPage,
      page: () =>
          const WebViewPage(loadResource: "", webViewType: WebViewType.URL),
    ),
    GetPage(
      name: RoutePath.aboutUs,
      page: () => const AboutUsPage(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => AboutUsViewModel());
      }),
    ),
    GetPage(
      name: RoutePath.search,
      page: () => const SearchPage(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => SearchViewModel());
      }),
    ),
    GetPage(
      name: RoutePath.scan,
      page: () => const ScanPage(),
    ),
    GetPage(
      name: RoutePath.settings,
      page: () => const SettingsPage(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => SettingsViewModel());
      }),
    ),
  ];
}
