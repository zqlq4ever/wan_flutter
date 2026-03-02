import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:oktoast/oktoast.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:wan_android_flutter/res/colors.dart';
import 'package:wan_android_flutter/utils/theme_controller.dart';
import 'package:wan_android_flutter/utils/locale_controller.dart';
import 'package:wan_android_flutter/utils/theme_util.dart';
import 'package:wan_android_flutter/res/app_strings.dart';

import '../../widgets/my_app_bar.dart';

/// 设置页面
///
/// 展示应用设置选项，包括：
/// - 通用设置：深色模式、语言切换
/// - 隐私安全：隐私政策、用户协议、清除缓存
/// - 其他：版本信息
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    return Scaffold(
      backgroundColor: isDark ? Colours.dark_bg_color : Colours.bg_color,
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
                _buildSectionTitle(AppStrings.getString('general_settings'), isDark),
                SizedBox(height: 16.h),
                _buildSettingsCard([
                  _buildThemeModeItem(isDark),
                  _buildLanguageItem(isDark),
                ], isDark),
                SizedBox(height: 32.h),
                _buildSectionTitle(AppStrings.getString('privacy_security'), isDark),
                SizedBox(height: 16.h),
                _buildSettingsCard([
                  _buildSettingsItem(
                    icon: Icons.lock_outline,
                    title: AppStrings.getString('privacy_policy'),
                    isDark: isDark,
                    onTap: () {},
                  ),
                  _buildSettingsItem(
                    icon: Icons.description_outlined,
                    title: AppStrings.getString('user_agreement'),
                    isDark: isDark,
                    onTap: () {},
                  ),
                  _buildClearCacheItem(isDark),
                ], isDark),
                SizedBox(height: 32.h),
                _buildSectionTitle(AppStrings.getString('other'), isDark),
                SizedBox(height: 16.h),
                _buildSettingsCard([
                  FutureBuilder<PackageInfo>(
                    future: PackageInfo.fromPlatform(),
                    builder: (context, snapshot) {
                      final version = snapshot.data?.version ?? "...";
                      return _buildSettingsItem(
                        icon: Icons.info_outline,
                        title: AppStrings.getString('version_info'),
                        isDark: isDark,
                        trailing: Text(
                          "v$version",
                          style: TextStyle(
                            color: isDark ? Colours.dark_text_gray : Colors.grey[500],
                            fontSize: 40.sp,
                          ),
                        ),
                      );
                    },
                  ),
                ], isDark),
                SizedBox(height: 60.h),
                Center(
                  child: Text(
                    "玩安卓 © ${DateTime.now().year}",
                    style: TextStyle(
                      color: isDark ? Colours.dark_text_gray : Colors.grey[400],
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

  /// 构建深色模式设置项
  ///
  /// 显示当前主题模式，点击可选择跟随系统/浅色/深色模式
  Widget _buildThemeModeItem(bool isDark) {
    return Obx(() {
      final controller = ThemeController.to;
      return _buildSettingsItem(
        icon: Icons.dark_mode_outlined,
        title: AppStrings.getString('dark_mode'),
        isDark: isDark,
        trailing: GestureDetector(
          onTap: () => _showThemeModeDialog(controller, isDark),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                controller.getThemeModeText(),
                style: TextStyle(
                  color: isDark ? Colours.dark_text_gray : Colors.grey[500],
                  fontSize: 40.sp,
                ),
              ),
              SizedBox(width: 8.w),
              Icon(
                Icons.arrow_forward_ios,
                size: 30.r,
                color: isDark ? Colours.dark_text_gray : Colors.grey[300],
              ),
            ],
          ),
        ),
        onTap: () => _showThemeModeDialog(controller, isDark),
      );
    });
  }

  Widget _buildLanguageItem(bool isDark) {
    return Obx(() {
      final controller = LocaleController.to;
      return _buildSettingsItem(
        icon: Icons.language_outlined,
        title: AppStrings.getString('language'),
        isDark: isDark,
        trailing: GestureDetector(
          onTap: () => _showLanguageDialog(controller, isDark),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                controller.getLocaleText(),
                style: TextStyle(
                  color: isDark ? Colours.dark_text_gray : Colors.grey[500],
                  fontSize: 40.sp,
                ),
              ),
              SizedBox(width: 8.w),
              Icon(
                Icons.arrow_forward_ios,
                size: 30.r,
                color: isDark ? Colours.dark_text_gray : Colors.grey[300],
              ),
            ],
          ),
        ),
        onTap: () => _showLanguageDialog(controller, isDark),
      );
    });
  }

  /// 显示主题模式选择对话框
  ///
  /// [controller] 主题控制器
  /// 提供跟随系统、浅色、深色三种选项
  void _showThemeModeDialog(ThemeController controller, bool isDark) {
    Get.dialog(
      AlertDialog(
        backgroundColor: isDark ? Colours.dark_card_bg : Colors.white,
        title: Text(
          AppStrings.getString('select_dark_mode'),
          style: TextStyle(color: isDark ? Colours.dark_text : Colors.black87),
        ),
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

  /// 显示语言选择对话框
  ///
  /// [controller] 语言控制器
  /// 提供中文、英文两种选项
  void _showLanguageDialog(LocaleController controller, bool isDark) {
    Get.dialog(
      AlertDialog(
        backgroundColor: isDark ? Colours.dark_card_bg : Colors.white,
        title: Text(
          AppStrings.getString('select_language'),
          style: TextStyle(color: isDark ? Colours.dark_text : Colors.black87),
        ),
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

  /// 构建主题模式选项
  ///
  /// [text] 选项文本
  /// [mode] 主题模式
  /// [currentMode] 当前选中的主题模式
  /// [onTap] 点击回调
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

  /// 构建语言选项
  ///
  /// [text] 选项文本
  /// [locale] 语言区域
  /// [currentLocale] 当前选中的语言
  /// [onTap] 点击回调
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

  /// 构建清除缓存设置项
  ///
  /// 显示当前缓存大小，点击可清除缓存
  Widget _buildClearCacheItem(bool isDark) {
    return _buildSettingsItem(
      icon: Icons.storage_outlined,
      title: AppStrings.getString('clear_cache'),
      isDark: isDark,
      trailing: FutureBuilder<String>(
        future: _getCacheSize(),
        builder: (context, snapshot) {
          return Text(
            snapshot.data ?? "...",
            style: TextStyle(
              color: isDark ? Colours.dark_text_gray : Colors.grey[500],
              fontSize: 40.sp,
            ),
          );
        },
      ),
      onTap: () => _showClearCacheDialog(isDark),
    );
  }

  /// 获取缓存大小
  ///
  /// 遍历缓存目录计算总大小
  /// 返回格式化后的缓存大小字符串
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

  /// 格式化字节数为可读字符串
  ///
  /// [bytes] 字节数
  /// 返回 B/KB/MB/GB 格式的字符串
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

  /// 显示清除缓存确认对话框
  void _showClearCacheDialog(bool isDark) {
    Get.dialog(
      AlertDialog(
        backgroundColor: isDark ? Colours.dark_card_bg : Colors.white,
        title: Text(
          AppStrings.getString('clear_cache'),
          style: TextStyle(color: isDark ? Colours.dark_text : Colors.black87),
        ),
        content: Text(
          AppStrings.getString('clear_cache_confirm'),
          style: TextStyle(color: isDark ? Colours.dark_text_gray : Colors.grey[600]),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              AppStrings.getString('cancel'),
              style: TextStyle(color: isDark ? Colours.dark_text_gray : Colors.grey[600]),
            ),
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

  /// 清除缓存
  ///
  /// 删除缓存目录下的所有文件
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

  /// 构建分区标题
  ///
  /// [title] 标题文本
  Widget _buildSectionTitle(String title, bool isDark) {
    return Padding(
      padding: EdgeInsets.only(left: 8.w),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 46.sp,
          color: isDark ? Colours.dark_text_gray : Colors.grey[600],
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  /// 构建设置卡片容器
  ///
  /// [children] 卡片内的子组件列表
  Widget _buildSettingsCard(List<Widget> children, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colours.dark_card_bg : Colors.white,
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
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
    required bool isDark,
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
                    color: isDark ? Colours.dark_text : Colors.black87,
                  ),
                ),
              ),
              if (trailing != null) trailing,
              if (trailing == null && onTap != null)
                Icon(
                  Icons.arrow_forward_ios,
                  size: 34.r,
                  color: isDark ? Colours.dark_text_gray : Colors.grey[300],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
