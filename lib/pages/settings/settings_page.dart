import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wan_android_flutter/res/colors.dart';

import '../../widgets/my_app_bar.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colours.bg_color,
      appBar: const MyAppBar(
        centerTitle: "设置",
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(24.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle("通用设置"),
                SizedBox(height: 16.h),
                _buildSettingsCard([
                  _buildSettingsItem(
                    icon: Icons.dark_mode_outlined,
                    title: "深色模式",
                    trailing: Switch(
                      value: false,
                      onChanged: (value) {},
                      activeColor: Colours.app_main,
                    ),
                  ),
                  _buildSettingsItem(
                    icon: Icons.notifications_outlined,
                    title: "消息推送",
                    trailing: Switch(
                      value: true,
                      onChanged: (value) {},
                      activeColor: Colours.app_main,
                    ),
                  ),
                  _buildSettingsItem(
                    icon: Icons.language_outlined,
                    title: "语言",
                    trailing: Text(
                      "跟随系统",
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 26.sp,
                      ),
                    ),
                  ),
                ]),
                SizedBox(height: 32.h),
                _buildSectionTitle("隐私与安全"),
                SizedBox(height: 16.h),
                _buildSettingsCard([
                  _buildSettingsItem(
                    icon: Icons.lock_outline,
                    title: "隐私政策",
                    onTap: () {},
                  ),
                  _buildSettingsItem(
                    icon: Icons.description_outlined,
                    title: "用户协议",
                    onTap: () {},
                  ),
                  _buildSettingsItem(
                    icon: Icons.storage_outlined,
                    title: "清除缓存",
                    trailing: Text(
                      "12.5MB",
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 26.sp,
                      ),
                    ),
                    onTap: () {},
                  ),
                ]),
                SizedBox(height: 32.h),
                _buildSectionTitle("其他"),
                SizedBox(height: 16.h),
                _buildSettingsCard([
                  _buildSettingsItem(
                    icon: Icons.help_outline,
                    title: "帮助与反馈",
                    onTap: () {},
                  ),
                  _buildSettingsItem(
                    icon: Icons.info_outline,
                    title: "版本信息",
                    trailing: Text(
                      "v1.0.0",
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 26.sp,
                      ),
                    ),
                  ),
                ]),
                SizedBox(height: 60.h),
                Center(
                  child: Text(
                    "玩安卓 © 2024",
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 24.sp,
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

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(left: 8.w),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 28.sp,
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
                width: 64.r,
                height: 64.r,
                decoration: BoxDecoration(
                  color: Colours.app_main.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Icon(
                  icon,
                  color: Colours.app_main,
                  size: 32.r,
                ),
              ),
              SizedBox(width: 24.w),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 30.sp,
                    color: Colors.black87,
                  ),
                ),
              ),
              if (trailing != null) trailing,
              if (trailing == null)
                Icon(
                  Icons.arrow_forward_ios,
                  size: 28.r,
                  color: Colors.grey[300],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
