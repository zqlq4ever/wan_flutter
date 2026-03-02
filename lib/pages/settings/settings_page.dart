import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:oktoast/oktoast.dart';
import 'package:wan_android_flutter/res/colors.dart';
import 'package:wan_android_flutter/utils/theme_controller.dart';
import 'package:wan_android_flutter/utils/locale_controller.dart';
import 'package:wan_android_flutter/res/app_strings.dart';

import '../../widgets/my_app_bar.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colours.bg_color,
      appBar: MyAppBar(
        centerTitle: AppStrings.getString('settings'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(24.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle(AppStrings.getString('general_settings')),
                SizedBox(height: 16.h),
                _buildSettingsCard([
                  _buildThemeModeItem(),
                  _buildLanguageItem(),
                ]),
                SizedBox(height: 32.h),
                _buildSectionTitle(AppStrings.getString('privacy_security')),
                SizedBox(height: 16.h),
                _buildSettingsCard([
                  _buildSettingsItem(
                    icon: Icons.lock_outline,
                    title: AppStrings.getString('privacy_policy'),
                    onTap: () {},
                  ),
                  _buildSettingsItem(
                    icon: Icons.description_outlined,
                    title: AppStrings.getString('user_agreement'),
                    onTap: () {},
                  ),
                  _buildClearCacheItem(),
                ]),
                SizedBox(height: 32.h),
                _buildSectionTitle(AppStrings.getString('other')),
                SizedBox(height: 16.h),
                _buildSettingsCard([
                  _buildSettingsItem(
                    icon: Icons.info_outline,
                    title: AppStrings.getString('version_info'),
                    trailing: Text(
                      "v1.0.0",
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 40.sp,
                      ),
                    ),
                  ),
                ]),
                SizedBox(height: 60.h),
                Center(
                  child: Text(
                    "玩安卓 © 2026",
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 40.sp,
                    ),
                  ),
                ),
                SizedBox(height: 100.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildThemeModeItem() {
    return Obx(() {
      final controller = ThemeController.to;
      return _buildSettingsItem(
        icon: Icons.dark_mode_outlined,
        title: AppStrings.getString('dark_mode'),
        trailing: GestureDetector(
          onTap: () => _showThemeModeDialog(controller),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                controller.getThemeModeText(),
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 40.sp,
                ),
              ),
              SizedBox(width: 8.w),
              Icon(
                Icons.arrow_forward_ios,
                size: 30.r,
                color: Colors.grey[300],
              ),
            ],
          ),
        ),
        onTap: () => _showThemeModeDialog(controller),
      );
    });
  }

  Widget _buildLanguageItem() {
    return Obx(() {
      final controller = LocaleController.to;
      return _buildSettingsItem(
        icon: Icons.language_outlined,
        title: AppStrings.getString('language'),
        trailing: GestureDetector(
          onTap: () => _showLanguageDialog(controller),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                controller.getLocaleText(),
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 40.sp,
                ),
              ),
              SizedBox(width: 8.w),
              Icon(
                Icons.arrow_forward_ios,
                size: 30.r,
                color: Colors.grey[300],
              ),
            ],
          ),
        ),
        onTap: () => _showLanguageDialog(controller),
      );
    });
  }

  void _showThemeModeDialog(ThemeController controller) {
    Get.dialog(
      AlertDialog(
        title: Text(AppStrings.getString('select_dark_mode')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildThemeModeOption(
              AppStrings.getString('follow_system'),
              ThemeMode.system,
              controller.themeMode,
              () => controller.setThemeMode(ThemeMode.system),
            ),
            _buildThemeModeOption(
              AppStrings.getString('light'),
              ThemeMode.light,
              controller.themeMode,
              () => controller.setThemeMode(ThemeMode.light),
            ),
            _buildThemeModeOption(
              AppStrings.getString('dark'),
              ThemeMode.dark,
              controller.themeMode,
              () => controller.setThemeMode(ThemeMode.dark),
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguageDialog(LocaleController controller) {
    Get.dialog(
      AlertDialog(
        title: Text(AppStrings.getString('select_language')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildLanguageOption(
              AppStrings.getString('chinese'),
              const Locale('zh', 'CN'),
              controller.locale,
              () => controller.setLocale(const Locale('zh', 'CN')),
            ),
            _buildLanguageOption(
              AppStrings.getString('english'),
              const Locale('en', 'US'),
              controller.locale,
              () => controller.setLocale(const Locale('en', 'US')),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeModeOption(
    String text,
    ThemeMode mode,
    ThemeMode currentMode,
    VoidCallback onTap,
  ) {
    final isSelected = mode == currentMode;
    return InkWell(
      onTap: () {
        onTap();
        Get.back();
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 24.h),
        child: Row(
          children: [
            Text(
              text,
              style: TextStyle(
                fontSize: 40.sp,
              ),
            ),
            const Spacer(),
            if (isSelected)
              Icon(
                Icons.check,
                color: Colours.app_main,
                size: 50.r,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageOption(
    String text,
    Locale locale,
    Locale currentLocale,
    VoidCallback onTap,
  ) {
    final isSelected = locale.languageCode == currentLocale.languageCode;
    return InkWell(
      onTap: () {
        onTap();
        Get.back();
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 24.h),
        child: Row(
          children: [
            Text(
              text,
              style: TextStyle(
                fontSize: 40.sp,
              ),
            ),
            const Spacer(),
            if (isSelected)
              Icon(
                Icons.check,
                color: Colours.app_main,
                size: 50.r,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildClearCacheItem() {
    return _buildSettingsItem(
      icon: Icons.storage_outlined,
      title: AppStrings.getString('clear_cache'),
      trailing: FutureBuilder<String>(
        future: _getCacheSize(),
        builder: (context, snapshot) {
          return Text(
            snapshot.data ?? "...",
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 40.sp,
            ),
          );
        },
      ),
      onTap: () => _showClearCacheDialog(),
    );
  }

  Future<String> _getCacheSize() async {
    try {
      final directory = Directory('${Directory.current.path}/cache');
      if (await directory.exists()) {
        int totalSize = 0;
        await for (var entity in directory.list(recursive: true)) {
          if (entity is File) {
            totalSize += await entity.length();
          }
        }
        return _formatBytes(totalSize);
      }
    } catch (e) {
      // ignore
    }
    return "0B";
  }

  String _formatBytes(int bytes) {
    if (bytes < 1024) {
      return "$bytes B";
    } else if (bytes < 1024 * 1024) {
      return "${(bytes / 1024).toStringAsFixed(1)} KB";
    } else if (bytes < 1024 * 1024 * 1024) {
      return "${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB";
    } else {
      return "${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB";
    }
  }

  void _showClearCacheDialog() {
    Get.dialog(
      AlertDialog(
        title: Text(AppStrings.getString('clear_cache')),
        content: Text(AppStrings.getString('clear_cache_confirm')),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(AppStrings.getString('cancel')),
          ),
          TextButton(
            onPressed: () async {
              await _clearCache();
              Get.back();
              showToast(AppStrings.getString('cache_cleared'));
            },
            child: Text(
              AppStrings.getString('confirm'),
              style: TextStyle(color: Colours.red),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _clearCache() async {
    try {
      final directory = Directory('${Directory.current.path}/cache');
      if (await directory.exists()) {
        await for (var entity in directory.list(recursive: true)) {
          if (entity is File) {
            await entity.delete();
          }
        }
      }
    } catch (e) {
      // ignore
    }
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(left: 8.w),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 46.sp,
          color: Colors.grey[600],
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildSettingsCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 28.h),
          child: Row(
            children: [
              Container(
                width: 80.r,
                height: 80.r,
                decoration: BoxDecoration(
                  color: Colours.app_main.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Icon(
                  icon,
                  color: Colours.app_main,
                  size: 50.r,
                ),
              ),
              SizedBox(width: 24.w),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 40.sp,
                    color: Colors.black87,
                  ),
                ),
              ),
              if (trailing != null) trailing,
              if (trailing == null && onTap != null)
                Icon(
                  Icons.arrow_forward_ios,
                  size: 34.r,
                  color: Colors.grey[300],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
