import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants.dart';
import '../res/app_strings.dart';
import '../res/theme_color.dart';
import 'sp_util.dart';

class ThemeController extends GetxController {
  static ThemeController get to => Get.find();

  final _themeMode = ThemeMode.system.obs;
  final _themeColor = Rx<ThemeColor>(ThemeColor.presetColors.first);

  ThemeMode get themeMode => _themeMode.value;
  ThemeColor get themeColor => _themeColor.value;

  @override
  void onInit() {
    super.onInit();
    ever(_themeMode, (_) => update());
    ever(_themeColor, (_) => update());
    _loadThemeMode();
    _loadThemeColor();
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

  Future<void> _loadThemeColor() async {
    final key = await SpUtil.getString(Constants.spThemeColor);
    if (key != null) {
      _themeColor.value = ThemeColor.fromKey(key);
    }
  }

  Future<void> setThemeColor(ThemeColor color) async {
    _themeColor.value = color;
    await SpUtil.saveString(Constants.spThemeColor, color.key);
  }

  String getThemeColorName() {
    return _themeColor.value.name;
  }
}
