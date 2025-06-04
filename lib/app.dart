import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oktoast/oktoast.dart';
import 'package:wan_android_flutter/route/RoutePath.dart';
import 'package:wan_android_flutter/route/RouteUtils.dart';
import 'package:wan_android_flutter/route/Routes.dart';

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
          return MaterialApp(
            theme: ThemeData(useMaterial3: true),
            navigatorKey: RouteUtils.navigatorKey,
            onGenerateRoute: Routes.generateRoute,
            initialRoute: RoutePath.tab,
          );
        },
      ),
    );
  }
}
