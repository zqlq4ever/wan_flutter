import 'package:flutter/material.dart';
import 'package:wan_android_flutter/pages/about/about_us_page.dart';
import 'package:wan_android_flutter/pages/auth/login_page.dart';
import 'package:wan_android_flutter/pages/auth/register_page.dart';
import 'package:wan_android_flutter/pages/knowledge/details/knowledge_details_tab_page.dart';
import 'package:wan_android_flutter/pages/my_collects/collection_page.dart';
import 'package:wan_android_flutter/pages/search/search_page.dart';
import 'package:wan_android_flutter/pages/tab_page.dart';

import '../widgets/web/webview_page.dart';
import '../widgets/web/webview_widget.dart';
import 'RoutePath.dart';

/// 路由注册管理类
class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      //首页tab
      case RoutePath.tab:
        return pageRoute(const BottomTabPage(), settings: settings);
      //知识体系明细页面
      case RoutePath.knowledgeDetails:
        return pageRoute(const KnowledgeDetailsTabPage(), settings: settings);
      //登录
      case RoutePath.login:
        return pageRoute(const LoginPage(), settings: settings);
      //注册
      case RoutePath.register:
        return pageRoute(const RegisterPage(), settings: settings);
      //我的收藏页面
      case RoutePath.myCollects:
        return pageRoute(const MyCollectsPage(), settings: settings);
      //显示网页资源的页面
      case RoutePath.webviewPage:
        return pageRoute(WebViewPage(loadResource: "", webViewType: WebViewType.URL), settings: settings);
      //关于我们
      case RoutePath.aboutUs:
        return pageRoute(const AboutUsPage(), settings: settings);
      //搜索页
      case RoutePath.search:
        return pageRoute(const SearchPage(), settings: settings);
    }
    return MaterialPageRoute(
      builder: (context) => Scaffold(
        body: Center(
          child: Text('No route defined for ${settings.name}'),
        ),
      ),
    );
  }

  static MaterialPageRoute pageRoute(
    Widget page, {
    RouteSettings? settings,
    bool? fullscreenDialog,
    bool? maintainState,
    bool? allowSnapshotting,
  }) {
    return MaterialPageRoute(
      builder: (context) => page,
      settings: settings,
      fullscreenDialog: fullscreenDialog ?? false,
      maintainState: maintainState ?? true,
      allowSnapshotting: allowSnapshotting ?? true,
    );
  }
}
