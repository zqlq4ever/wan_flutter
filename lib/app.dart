import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:oktoast/oktoast.dart';
import 'package:wan_android_flutter/res/colors.dart';
import 'package:wan_android_flutter/route/route_page_util.dart';
import 'package:wan_android_flutter/route/route_path_constant.dart';

/// 设计尺寸
Size get designSize {
  // 使用固定的设计尺寸，确保UI元素在不同窗口大小下保持一致比例
  return const Size(1080, 1920);
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
            theme: ThemeData(
              useMaterial3: true,
              primaryColor: Colours.app_main,
              scaffoldBackgroundColor: Colors.white,
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colours.app_main,
                primary: Colours.app_main,
                surface: Colors.white,
              ),
            ),
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
