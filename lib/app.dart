import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:oktoast/oktoast.dart';
import 'package:wan_android_flutter/res/colors.dart';
import 'package:wan_android_flutter/route/route_page_util.dart';
import 'package:wan_android_flutter/route/route_path_constant.dart';

import 'utils/theme_controller.dart';
import 'utils/locale_controller.dart';

/// 设计尺寸
Size get designSize {
  return const Size(1080, 1920);
}

class AppInit {
  static final ThemeController themeController = Get.put(ThemeController());
  static final LocaleController localeController = Get.put(LocaleController());
}

class WanApp extends StatelessWidget {
  const WanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return OKToast(
      child: ScreenUtilInit(
        designSize: designSize,
        builder: (context, child) {
          return _AppWrapper();
        },
      ),
    );
  }
}

class _AppWrapper extends StatefulWidget {
  @override
  State<_AppWrapper> createState() => _AppWrapperState();
}

class _AppWrapperState extends State<_AppWrapper> {
  @override
  void initState() {
    super.initState();
    AppInit.themeController;
    AppInit.localeController;
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([
        AppInit.themeController,
        AppInit.localeController,
      ]),
      builder: (context, child) {
        return GetMaterialApp(
          title: 'WanAndroid',
          themeMode: AppInit.themeController.themeMode,
          locale: AppInit.localeController.locale,
          fallbackLocale: const Locale('zh', 'CN'),
          supportedLocales: LocaleController.supportedLocales,
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
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
          darkTheme: ThemeData(
            useMaterial3: true,
            primaryColor: Colours.app_main,
            brightness: Brightness.dark,
            scaffoldBackgroundColor: Colours.dark_bg_color,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colours.app_main,
              primary: Colours.app_main,
              brightness: Brightness.dark,
              surface: Colours.dark_bg_color,
            ),
          ),
          initialRoute: RoutePath.tab,
          defaultTransition: Transition.rightToLeftWithFade,
          getPages: RoutePageUtil.pages,
        );
      },
    );
  }
}
