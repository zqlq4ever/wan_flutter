import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants.dart';
import '../res/app_strings.dart';
import '../utils/sp_util.dart';

class LocaleController extends GetxController {
  static LocaleController get to => Get.find();

  final _locale = const Locale('zh', 'CN').obs;

  Locale get locale => _locale.value;

  static const List<Locale> supportedLocales = [
    Locale('zh', 'CN'),
    Locale('en', 'US'),
  ];

  @override
  void onInit() {
    super.onInit();
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    final languageCode = await SpUtil.getString(Constants.spLanguageCode);
    final countryCode = await SpUtil.getString(Constants.spLanguageCountry);
    if (languageCode != null) {
      _locale.value = Locale(languageCode, countryCode);
      Get.updateLocale(_locale.value);
    }
  }

  Future<void> setLocale(Locale locale) async {
    _locale.value = locale;
    await SpUtil.saveString(Constants.spLanguageCode, locale.languageCode);
    if (locale.countryCode != null) {
      await SpUtil.saveString(Constants.spLanguageCountry, locale.countryCode!);
    }
    Get.updateLocale(locale);
  }

  String getLocaleText() {
    switch (_locale.value.languageCode) {
      case 'zh':
        return AppStrings.getString('chinese');
      case 'en':
        return AppStrings.getString('english');
      default:
        return AppStrings.getString('chinese');
    }
  }

  String getLocaleModeText() {
    final mode = _locale.value.languageCode;
    if (mode == 'system' || _locale.value.countryCode == null) {
      return AppStrings.getString('follow_system');
    }
    return getLocaleText();
  }
}
