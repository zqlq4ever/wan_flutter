import 'package:get/get.dart';

import '../pages/about/about_us_page.dart';
import '../pages/auth/login/login_page.dart';
import '../pages/auth/login/login_viewmodel.dart';
import '../pages/auth/register/register_page.dart';
import '../pages/auth/register/register_viewmodel.dart';
import '../pages/knowledge/details/knowledge_details_page.dart';
import '../pages/my_collects/collection_page.dart';
import '../pages/my_collects/collection_viewmodel.dart';
import '../pages/search/search_page.dart';
import '../pages/home_bottom_tab.dart';
import '../widgets/web/webview_page.dart';
import '../widgets/web/webview_widget.dart';
import 'RoutePath.dart';

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
    GetPage(name: RoutePath.knowledgeDetails, page: () => const KnowledgeDetailsPage()),
    GetPage(
      name: RoutePath.register,
      page: () => const RegisterPage(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => RegisterViewModel());
      }),
    ),
    GetPage(
      name: RoutePath.myCollection,
      page: () => const MyCollectsPage(),
      binding: BindingsBuilder(() {
        Get.lazyPut(() => CollectionViewmodel());
      }),
    ),
    GetPage(
      name: RoutePath.webviewPage,
      page: () => const WebViewPage(loadResource: "", webViewType: WebViewType.URL),
    ),
    GetPage(name: RoutePath.aboutUs, page: () => const AboutUsPage()),
    GetPage(name: RoutePath.search, page: () => const SearchPage()),
  ];
}
