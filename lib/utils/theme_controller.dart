import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants.dart';
import '../res/app_strings.dart';
import 'sp_util.dart';

class ThemeController extends GetxController {
  static ThemeController get to => Get.find();

  final _themeMode = ThemeMode.system.obs;

  ThemeMode get themeMode => _themeMode.value;

  @override
  void onInit() {
    super.onInit();
    ever(_themeMode, (_) => update());
    _loadThemeMode();
  }

  Future<void> _loadThemeMode() async {
    final mode = await SpUtil.getInt(Constants.spThemeMode);
    if (mode != null) {
      _themeMode.value = ThemeMode.values[mode];
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode.value = mode;
    await SpUtil.saveInt(Constants.spThemeMode, mode.index);
  }

  String getThemeModeText() {
    switch (_themeMode.value) {
      case ThemeMode.system:
        return AppStrings.getString('follow_system');
      case ThemeMode.light:
        return AppStrings.getString('light');
      case ThemeMode.dark:
        return AppStrings.getString('dark');
    }
  }
}
