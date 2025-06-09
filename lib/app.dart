import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:oktoast/oktoast.dart';
import 'package:wan_android_flutter/pages/about/about_us_page.dart';
import 'package:wan_android_flutter/pages/auth/login_page.dart';
import 'package:wan_android_flutter/pages/auth/register_page.dart';
import 'package:wan_android_flutter/pages/knowledge/details/knowledge_details_tab_page.dart';
import 'package:wan_android_flutter/pages/my_collects/collection_page.dart';
import 'package:wan_android_flutter/pages/search/search_page.dart';
import 'package:wan_android_flutter/pages/tab_page.dart';
import 'package:wan_android_flutter/route/RoutePath.dart';
import 'package:wan_android_flutter/widgets/web/webview_page.dart';
import 'package:wan_android_flutter/widgets/web/webview_widget.dart';

/// 设计尺寸
Size get designSize {
  final firstView = WidgetsBinding.instance.platformDispatcher.views.first;
  //  逻辑短边
  final logicalShortestSide = firstView.physicalSize.shortestSide / firstView.devicePixelRatio;
  //  逻辑长边
  final logicalLongestSide = firstView.physicalSize.longestSide / firstView.devicePixelRatio;
  //  缩放比例 designSize 越小，元素越大
  const scaleFactor = 0.95;
  //  缩放后的逻辑短边和长边
  return Size(logicalShortestSide * scaleFactor, logicalLongestSide * scaleFactor);
}

class WanApp extends StatelessWidget {
  const WanApp({super.key});

  @override
  Widget build(BuildContext context) {
    //  包裹你的 MaterialApp,不是包裹你的 Scaffold
    //  这一步解释一下,因为一般情况下,一个 flutter 应用应该只有一个 MaterialApp(或是 WidgetsApp/CupertinoApp),
    //  这里包裹后,可以缓存 Context 到 内存中,后续在调用显示时,不用传入 BuildContext
    //  这样能满足一部分用户在无 context 的情况下调用 showToast 方法
    return OKToast(
      //  屏幕适配父组件组件
      child: ScreenUtilInit(
        designSize: designSize,
        builder: (context, child) {
          return GetMaterialApp(
            theme: ThemeData(useMaterial3: true),
            initialRoute: RoutePath.tab,
            defaultTransition: Transition.rightToLeftWithFade,
            // 路由配置表
            getPages: [
              GetPage(name: RoutePath.login, page: () => LoginPage()),
              GetPage(name: RoutePath.tab, page: () => const BottomTabPage()),
              GetPage(name: RoutePath.knowledgeDetails, page: () => const KnowledgeDetailsTabPage()),
              GetPage(name: RoutePath.register, page: () => RegisterPage()),
              GetPage(name: RoutePath.myCollects, page: () => const MyCollectsPage()),
              GetPage(
                name: RoutePath.webviewPage,
                page: () => const WebViewPage(loadResource: "", webViewType: WebViewType.URL),
              ),
              GetPage(name: RoutePath.aboutUs, page: () => const AboutUsPage()),
              GetPage(name: RoutePath.search, page: () => const SearchPage()),
            ],
          );
        },
      ),
    );
  }
}
