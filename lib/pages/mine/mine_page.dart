import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:wan_android_flutter/pages/mine/mine_viewmodel.dart';
import 'package:wan_android_flutter/res/app_strings.dart';
import 'package:wan_android_flutter/res/colors.dart';
import 'package:wan_android_flutter/utils/theme_util.dart';

import '../../route/route_path_constant.dart';
import '../../widgets/dialog/update_dialog.dart';

/// 我的页面
///
/// 展示用户个人信息和功能菜单
/// 包含：用户头像、用户名、会员等级、功能菜单列表、退出登录按钮
class MinePage extends StatefulWidget {
  const MinePage({super.key});

  @override
  State<MinePage> createState() => _MinePageState();
}

class _MinePageState extends State<MinePage> {
  var vm = MineViewModel();
  bool _isDialogShowing = false;

  @override
  void initState() {
    super.initState();
    vm.initData();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    return ChangeNotifierProvider(
      create: (context) => vm,
      child: Scaffold(
        backgroundColor: isDark ? Colours.dark_bg_color : Colours.bg_color,
        body: Column(
          children: [
            _buildHeaderBackground(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildMenuSection(),
                    SizedBox(height: 40.h),
                    _buildLogoutButton(),
                    SizedBox(height: 100.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 构建头部背景区域
  ///
  /// 包含渐变背景、装饰圆形和用户信息
  Widget _buildHeaderBackground() {
    final isDark = context.isDark;
    return Container(
      width: double.infinity,
      height: 560.h,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  Color(0xFF2A2A2A),
                  Color(0xFF1A1A1A),
                ]
              : [
                  Color(0xFF667eea),
                  Color(0xFF764ba2),
                ],
        ),
      ),
      child: Stack(
        children: [
          _buildDecorCircle(
            right: -50.w,
            top: MediaQuery.of(context).padding.top - 30.h,
            size: 300.w,
            alpha: isDark ? 0.08 : 0.15,
          ),
          _buildDecorCircle(
            left: -30.w,
            bottom: 50.h,
            size: 200.w,
            alpha: isDark ? 0.05 : 0.1,
          ),
          _buildDecorCircle(
            right: 80.w,
            bottom: 100.h,
            size: 120.w,
            alpha: isDark ? 0.03 : 0.08,
          ),
          _buildUserInfo(),
        ],
      ),
    );
  }

  /// 构建装饰圆形
  Widget _buildDecorCircle({
    double? right,
    double? left,
    double? top,
    double? bottom,
    required double size,
    required double alpha,
  }) {
    return Positioned(
      right: right,
      left: left,
      top: top,
      bottom: bottom,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withValues(alpha: alpha),
        ),
      ),
    );
  }

  /// 构建用户信息区域
  ///
  /// 包含头像、用户名、会员等级标签
  /// 未登录时点击头像跳转登录页
  Widget _buildUserInfo() {
    return SizedBox(
      width: double.infinity,
      height: 560.h,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 60.h),
            _buildUserAvatar(),
            SizedBox(height: 24.h),
            _buildUserName(),
            SizedBox(height: 20.h),
            _buildMemberBadge(),
          ],
        ),
      ),
    );
  }

  /// 构建用户头像
  Widget _buildUserAvatar() {
    return Selector<MineViewModel, bool>(
      selector: (context, vm) => vm.shouldLogin ?? true,
      builder: (context, shouldLogin, child) {
        final isDark = context.isDark;
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            if (shouldLogin) {
              Get.toNamed(RoutePath.login);
            }
          },
          child: Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: ClipOval(
              child: CachedNetworkImage(
                width: 160.r,
                height: 160.r,
                fit: BoxFit.cover,
                imageUrl: "https://picsum.photos/100/100",
                placeholder: (context, url) => Container(
                  width: 160.r,
                  height: 160.r,
                  color: isDark ? Colours.dark_bg_gray : Colors.grey[200],
                  child: Icon(Icons.person, size: 60.r, color: isDark ? Colours.dark_text_gray : Colors.grey),
                ),
                errorWidget: (context, url, error) => Container(
                  width: 160.r,
                  height: 160.r,
                  color: isDark ? Colours.dark_bg_gray : Colors.grey[200],
                  child: Icon(Icons.person, size: 60.r, color: isDark ? Colours.dark_text_gray : Colors.grey),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  /// 构建用户名
  Widget _buildUserName() {
    return Selector<MineViewModel, String?>(
      builder: (context, value, child) {
        return Text(
          value ?? AppStrings.getString('click_login'),
          style: TextStyle(
            color: Colors.white,
            fontSize: 44.sp,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                color: Colors.black.withValues(alpha: 0.2),
                offset: const Offset(0, 2),
                blurRadius: 4,
              ),
            ],
          ),
        );
      },
      selector: (context, value) {
        return value.userName;
      },
    );
  }

  /// 构建会员等级标签
  Widget _buildMemberBadge() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(30.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.verified_user_outlined,
            color: Colors.white,
            size: 28.r,
          ),
          SizedBox(width: 8.w),
          Text(
            AppStrings.getString('level_super_member'),
            style: TextStyle(
              color: Colors.white,
              fontSize: 30.sp,
            ),
          ),
        ],
      ),
    );
  }

  /// 构建菜单区域
  ///
  /// 包含：我的收藏、检查更新、关于我们、设置
  Widget _buildMenuSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        children: [
          SizedBox(height: 20.h),
          _buildMenuItem(
            icon: Icons.favorite_outline,
            title: AppStrings.getString('my_collection'),
            onTap: () {
              if (vm.shouldLogin == true) {
                Get.toNamed(RoutePath.login);
              } else {
                Get.toNamed(RoutePath.myCollection);
              }
            },
          ),
          SizedBox(height: 20.h),
          Selector<MineViewModel, bool>(builder: (context, value, child) {
            return _buildMenuItem(
              icon: Icons.system_update_outlined,
              title: AppStrings.getString('check_update'),
              showRedDot: value,
              onTap: () {
                checkAppUpdate();
              },
            );
          }, selector: (context, vm) {
            return vm.needUpdate;
          }),
          SizedBox(height: 20.h),
          _buildMenuItem(
            icon: Icons.info_outline,
            title: AppStrings.getString('about_us'),
            onTap: () {
              Get.toNamed(RoutePath.aboutUs);
            },
          ),
          SizedBox(height: 20.h),
          _buildMenuItem(
            icon: Icons.settings_outlined,
            title: AppStrings.getString('settings'),
            onTap: () {
              Get.toNamed(RoutePath.settings);
            },
          ),
        ],
      ),
    );
  }

  /// 构建菜单项
  ///
  /// [icon] 图标
  /// [title] 标题
  /// [onTap] 点击回调
  /// [showRedDot] 是否显示红点
  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required GestureTapCallback onTap,
    bool? showRedDot,
  }) {
    final isDark = context.isDark;
    final primaryColor = Theme.of(context).primaryColor;
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
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(24.r),
        child: InkWell(
          borderRadius: BorderRadius.circular(24.r),
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 32.h),
            child: Row(
              children: [
                Container(
                  width: 100.r,
                  height: 100.r,
                  decoration: BoxDecoration(
                    color: primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Icon(
                    icon,
                    color: primaryColor,
                    size: 60.r,
                  ),
                ),
                SizedBox(width: 24.w),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 40.sp,
                      color: isDark ? Colours.dark_text : Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                if (showRedDot == true)
                  Container(
                    width: 16.r,
                    height: 16.r,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                SizedBox(width: 16.w),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 32.r,
                  color: isDark ? Colours.dark_text_gray : Colors.grey[300],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 构建退出登录按钮
  ///
  /// 仅在已登录状态下显示
  Widget _buildLogoutButton() {
    final isDark = context.isDark;
    return Selector<MineViewModel, bool>(builder: (context, value, child) {
      return !value
          ? Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: SizedBox(
                width: double.infinity,
                height: 100.h,
                child: ElevatedButton(
                  onPressed: () {
                    vm.logout();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDark ? Colours.dark_card_bg : Colors.white,
                    foregroundColor: Colors.red,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24.r),
                    ),
                  ),
                  child: Text(
                    AppStrings.getString('logout'),
                    style: TextStyle(
                      fontSize: 40.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            )
          : const SizedBox();
    }, selector: (context, m) {
      return m.shouldLogin ?? false;
    });
  }

  void checkAppUpdate() {
    if (_isDialogShowing) return;
    vm.checkUpdate().then((url) {
      if (url == null || url.isEmpty) {
        showToast(AppStrings.getString('already_latest_version'));
        return;
      }
      _showUpdateDialog();
    });
  }

  void _showUpdateDialog() {
    if (_isDialogShowing) return;
    _isDialogShowing = true;
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const UpdateDialog(),
    ).whenComplete(() {
      _isDialogShowing = false;
    });
  }
}
