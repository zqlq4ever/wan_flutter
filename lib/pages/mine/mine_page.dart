import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:wan_android_flutter/pages/mine/mine_viewmodel.dart';
import 'package:wan_android_flutter/res/colors.dart';
import 'package:wan_android_flutter/widgets/my_button.dart';

import '../../route/route_path_constant.dart';
import '../../widgets/dialog/update_dialog.dart';

class MinePage extends StatefulWidget {
  const MinePage({super.key});

  @override
  State<MinePage> createState() => _MinePageState();
}

class _MinePageState extends State<MinePage> {
  var vm = MineViewModel();

  @override
  void initState() {
    super.initState();
    vm.initData();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => vm,
      child: Scaffold(
        backgroundColor: Colours.bg_color,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildHeader(),
                SizedBox(height: 20.h),
                _buildMenuSection(),
                SizedBox(height: 40.h),
                _buildLogoutButton(),
                SizedBox(height: 100.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      height: 480.h,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colours.app_main,
            Colours.app_main.withValues(alpha: 0.8),
          ],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -50.w,
            top: -30.h,
            child: Container(
              width: 300.w,
              height: 300.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.1),
              ),
            ),
          ),
          Positioned(
            left: -30.w,
            bottom: 50.h,
            child: Container(
              width: 200.w,
              height: 200.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.08),
              ),
            ),
          ),
          _buildUserInfo(),
        ],
      ),
    );
  }

  Widget _buildUserInfo() {
    return SizedBox(
      width: double.infinity,
      height: 480.h,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                log("点击头像或者用户名去登录");
                if (vm.shouldLogin == true) {
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
                    width: 140.r,
                    height: 140.r,
                    fit: BoxFit.cover,
                    imageUrl: "https://picsum.photos/100/100",
                    placeholder: (context, url) => Container(
                      color: Colors.grey[200],
                      child: Icon(Icons.person, size: 60.r, color: Colors.grey),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 24.h),
            Selector<MineViewModel, String?>(
              builder: (context, value, child) {
                return Text(
                  value ?? "点击登录",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 36.sp,
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
            ),
            SizedBox(height: 12.h),
            Container(
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
                    "等级: 超级会员",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24.sp,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        children: [
          _buildMenuItem(
            icon: Icons.favorite_outline,
            title: "我的收藏",
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
              title: "检查更新",
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
            title: "关于我们",
            onTap: () {
              Get.toNamed(RoutePath.aboutUs);
            },
          ),
          SizedBox(height: 20.h),
          _buildMenuItem(
            icon: Icons.settings_outlined,
            title: "设置",
            onTap: () {
              Get.toNamed(RoutePath.settings);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required GestureTapCallback onTap,
    bool? showRedDot,
  }) {
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
                  width: 80.r,
                  height: 80.r,
                  decoration: BoxDecoration(
                    color: Colours.app_main.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Icon(
                    icon,
                    color: Colours.app_main,
                    size: 40.r,
                  ),
                ),
                SizedBox(width: 24.w),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 30.sp,
                      color: Colors.black87,
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
                  color: Colors.grey[300],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutButton() {
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
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.red,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24.r),
                    ),
                  ),
                  child: Text(
                    "退出登录",
                    style: TextStyle(
                      fontSize: 32.sp,
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
    vm.checkUpdate().then((url) {
      if (url == null || url.isEmpty) {
        showToast("已是最新版本");
        return;
      }
      _showUpdateDialog();
    });
  }

  void _showUpdateDialog() {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const UpdateDialog(),
    );
  }
}
