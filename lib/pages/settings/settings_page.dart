import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:oktoast/oktoast.dart';
import 'package:wan_android_flutter/res/colors.dart';
import 'package:wan_android_flutter/res/theme_color.dart';
import 'package:wan_android_flutter/utils/theme_controller.dart';
import 'package:wan_android_flutter/utils/locale_controller.dart';
import 'package:wan_android_flutter/utils/theme_util.dart';
import 'package:wan_android_flutter/res/app_strings.dart';
import 'package:wan_android_flutter/pages/settings/settings_viewmodel.dart';

import '../../widgets/my_app_bar.dart';

class SettingsPage extends GetView<SettingsViewModel> {
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
                _buildSectionTitle(
                    AppStrings.getString('general_settings'), isDark),
                SizedBox(height: 16.h),
                _buildSettingsCard([
                  _buildThemeModeItem(context, isDark),
                  _buildThemeColorItem(context, isDark),
                  _buildLanguageItem(context, isDark),
                ], isDark),
                SizedBox(height: 32.h),
                _buildSectionTitle(
                    AppStrings.getString('privacy_security'), isDark),
                SizedBox(height: 16.h),
                _buildSettingsCard([
                  _buildSettingsItem(
                    context: context,
                    icon: Icons.lock_outline,
                    title: AppStrings.getString('privacy_policy'),
                    isDark: isDark,
                    onTap: () {},
                  ),
                  _buildSettingsItem(
                    context: context,
                    icon: Icons.description_outlined,
                    title: AppStrings.getString('user_agreement'),
                    isDark: isDark,
                    onTap: () {},
                  ),
                  _buildClearCacheItem(context, isDark),
                ], isDark),
                SizedBox(height: 32.h),
                _buildSectionTitle(AppStrings.getString('other'), isDark),
                SizedBox(height: 16.h),
                _buildSettingsCard([
                  _buildVersionItem(context, isDark),
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

  Widget _buildVersionItem(BuildContext context, bool isDark) {
    return Obx(() => _buildSettingsItem(
          context: context,
          icon: Icons.info_outline,
          title: AppStrings.getString('version_info'),
          isDark: isDark,
          trailing: Text(
            "v${controller.version}",
            style: TextStyle(
              color: isDark ? Colours.dark_text_gray : Colors.grey[500],
              fontSize: 40.sp,
            ),
          ),
        ));
  }

  Widget _buildThemeModeItem(BuildContext context, bool isDark) {
    return Obx(() {
      final themeController = ThemeController.to;
      return _buildSettingsItem(
        context: context,
        icon: Icons.dark_mode_outlined,
        title: AppStrings.getString('dark_mode'),
        isDark: isDark,
        trailing: _buildTrailingArrow(
          text: themeController.getThemeModeText(),
          isDark: isDark,
        ),
        onTap: () => _showThemeModeDialog(context, themeController, isDark),
      );
    });
  }

  Widget _buildThemeColorItem(BuildContext context, bool isDark) {
    return Obx(() {
      final themeController = ThemeController.to;
      final themeColor = themeController.themeColor;
      return _buildSettingsItem(
        context: context,
        icon: Icons.palette_outlined,
        title: AppStrings.getString('theme_color'),
        isDark: isDark,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 50.r,
              height: 50.r,
              decoration: BoxDecoration(
                color: themeColor.color,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isDark ? Colors.white24 : Colors.black12,
                  width: 1,
                ),
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
        onTap: () => _showThemeColorPicker(context, isDark),
      );
    });
  }

  Widget _buildLanguageItem(BuildContext context, bool isDark) {
    return Obx(() {
      final localeController = LocaleController.to;
      return _buildSettingsItem(
        context: context,
        icon: Icons.language_outlined,
        title: AppStrings.getString('language'),
        isDark: isDark,
        trailing: _buildTrailingArrow(
          text: localeController.getLocaleText(),
          isDark: isDark,
        ),
        onTap: () => _showLanguageDialog(context, localeController, isDark),
      );
    });
  }

  Widget _buildTrailingArrow({required String text, required bool isDark}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          text,
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
    );
  }

  Widget _buildClearCacheItem(BuildContext context, bool isDark) {
    return Obx(() => _buildSettingsItem(
          context: context,
          icon: Icons.storage_outlined,
          title: AppStrings.getString('clear_cache'),
          isDark: isDark,
          trailing: Text(
            controller.cacheSize,
            style: TextStyle(
              color: isDark ? Colours.dark_text_gray : Colors.grey[500],
              fontSize: 40.sp,
            ),
          ),
          onTap: () => _showClearCacheDialog(context, isDark),
        ));
  }

  void _showThemeModeDialog(
      BuildContext context, ThemeController controller, bool isDark) {
    final primaryColor = Theme.of(context).primaryColor;
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
            _buildOptionItem(
              AppStrings.getString('follow_system'),
              isSelected: controller.themeMode == ThemeMode.system,
              primaryColor: primaryColor,
              onTap: () {
                controller.setThemeMode(ThemeMode.system);
                Get.back();
              },
            ),
            _buildOptionItem(
              AppStrings.getString('light'),
              isSelected: controller.themeMode == ThemeMode.light,
              primaryColor: primaryColor,
              onTap: () {
                controller.setThemeMode(ThemeMode.light);
                Get.back();
              },
            ),
            _buildOptionItem(
              AppStrings.getString('dark'),
              isSelected: controller.themeMode == ThemeMode.dark,
              primaryColor: primaryColor,
              onTap: () {
                controller.setThemeMode(ThemeMode.dark);
                Get.back();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showThemeColorPicker(BuildContext context, bool isDark) {
    final controller = ThemeController.to;
    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? Colours.dark_card_bg : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(32.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 80.w,
                  height: 8.h,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white24 : Colors.black12,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
              ),
              SizedBox(height: 32.h),
              Text(
                AppStrings.getString('select_theme_color'),
                style: TextStyle(
                  fontSize: 48.sp,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colours.dark_text : Colors.black87,
                ),
              ),
              SizedBox(height: 48.h),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  mainAxisSpacing: 32.h,
                  crossAxisSpacing: 32.w,
                  childAspectRatio: 0.9,
                ),
                itemCount: ThemeColor.presetColors.length,
                itemBuilder: (context, index) {
                  final color = ThemeColor.presetColors[index];
                  return Obx(() => _buildColorItem(
                        color,
                        controller.themeColor.key == color.key,
                        isDark,
                        () => controller.setThemeColor(color),
                      ));
                },
              ),
              SizedBox(height: 48.h),
            ],
          ),
        );
      },
    );
  }

  Widget _buildColorItem(
    ThemeColor themeColor,
    bool isSelected,
    bool isDark,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 100.r,
            height: 100.r,
            decoration: BoxDecoration(
              color: themeColor.color,
              shape: BoxShape.circle,
              border: isSelected
                  ? Border.all(
                      color: isDark ? Colors.white : Colors.black87,
                      width: 4,
                    )
                  : null,
              boxShadow: [
                BoxShadow(
                  color: themeColor.color.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: isSelected
                ? Icon(
                    Icons.check,
                    color: _getCheckColor(themeColor.color),
                    size: 50.r,
                  )
                : null,
          ),
          SizedBox(height: 12.h),
          Text(
            themeColor.name,
            style: TextStyle(
              fontSize: 32.sp,
              color: isDark ? Colours.dark_text_gray : Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Color _getCheckColor(Color backgroundColor) {
    final luminance = backgroundColor.computeLuminance();
    return luminance > 0.5 ? Colors.black87 : Colors.white;
  }

  void _showLanguageDialog(
      BuildContext context, LocaleController controller, bool isDark) {
    final primaryColor = Theme.of(context).primaryColor;
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
            _buildOptionItem(
              AppStrings.getString('chinese'),
              isSelected: controller.locale.languageCode == 'zh',
              primaryColor: primaryColor,
              onTap: () {
                controller.setLocale(const Locale('zh', 'CN'));
                Get.back();
              },
            ),
            _buildOptionItem(
              AppStrings.getString('english'),
              isSelected: controller.locale.languageCode == 'en',
              primaryColor: primaryColor,
              onTap: () {
                controller.setLocale(const Locale('en', 'US'));
                Get.back();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionItem(
    String text, {
    required bool isSelected,
    required Color primaryColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 24.h),
        child: Row(
          children: [
            Text(
              text,
              style: TextStyle(fontSize: 40.sp),
            ),
            const Spacer(),
            if (isSelected)
              Icon(
                Icons.check,
                color: primaryColor,
                size: 50.r,
              ),
          ],
        ),
      ),
    );
  }

  void _showClearCacheDialog(BuildContext context, bool isDark) {
    Get.dialog(
      AlertDialog(
        backgroundColor: isDark ? Colours.dark_card_bg : Colors.white,
        title: Text(
          AppStrings.getString('clear_cache'),
          style: TextStyle(color: isDark ? Colours.dark_text : Colors.black87),
        ),
        content: Text(
          AppStrings.getString('clear_cache_confirm'),
          style: TextStyle(
              color: isDark ? Colours.dark_text_gray : Colors.grey[600]),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              AppStrings.getString('cancel'),
              style: TextStyle(
                  color: isDark ? Colours.dark_text_gray : Colors.grey[600]),
            ),
          ),
          TextButton(
            onPressed: () async {
              Get.back();
              await controller.clearCache();
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
    required BuildContext context,
    required IconData icon,
    required String title,
    Widget? trailing,
    VoidCallback? onTap,
    required bool isDark,
  }) {
    final primaryColor = Theme.of(context).primaryColor;
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
                  color: primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Icon(
                  icon,
                  color: primaryColor,
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
