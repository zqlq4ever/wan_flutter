import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:oktoast/oktoast.dart';
import 'package:wan_android_flutter/route/RoutePageUtil.dart';
import 'package:wan_android_flutter/route/RoutePath.dart';

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
    return OKToast(
      //  屏幕适配父组件组件
      child: ScreenUtilInit(
        designSize: designSize,
        builder: (context, child) {
          return GetMaterialApp(
            theme: ThemeData(useMaterial3: true),
            initialRoute: RoutePath.tab,
            defaultTransition: Transition.rightToLeftWithFade,
            //  路由配置表
            getPages: RoutePageUtil.pages,
          );
        },
      ),
    );
  }
}
