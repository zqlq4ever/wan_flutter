import 'package:get/get.dart';

class AppStrings {
  static const Map<String, Map<String, String>> localizedValues = {
    'zh': {
      'app_name': '玩安卓',
      'settings': '设置',
      'dark_mode': '深色模式',
      'follow_system': '跟随系统',
      'light': '浅色',
      'dark': '深色',
      'language': '语言',
      'privacy_policy': '隐私政策',
      'user_agreement': '用户协议',
      'clear_cache': '清除缓存',
      'version_info': '版本信息',
      'clear_cache_confirm': '确定要清除所有缓存吗？',
      'cancel': '取消',
      'confirm': '确定',
      'cache_cleared': '缓存已清除',
      'select_dark_mode': '选择深色模式',
      'select_language': '选择语言',
      'chinese': '中文',
      'english': 'English',
      'general_settings': '通用设置',
      'privacy_security': '隐私与安全',
      'other': '其他',
    },
    'en': {
      'app_name': 'WanAndroid',
      'settings': 'Settings',
      'dark_mode': 'Dark Mode',
      'follow_system': 'Follow System',
      'light': 'Light',
      'dark': 'Dark',
      'language': 'Language',
      'privacy_policy': 'Privacy Policy',
      'user_agreement': 'User Agreement',
      'clear_cache': 'Clear Cache',
      'version_info': 'Version Info',
      'clear_cache_confirm': 'Are you sure to clear all cache?',
      'cancel': 'Cancel',
      'confirm': 'Confirm',
      'cache_cleared': 'Cache cleared',
      'select_dark_mode': 'Select Dark Mode',
      'select_language': 'Select Language',
      'chinese': 'Chinese',
      'english': 'English',
      'general_settings': 'General',
      'privacy_security': 'Privacy & Security',
      'other': 'Other',
    },
  };

  static String getString(String key) {
    final code = Get.locale?.languageCode ?? 'zh';
    return localizedValues[code]?[key] ?? localizedValues['zh']?[key] ?? key;
  }
}
