import 'dart:developer';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:wan_android_flutter/pages/mine/mine_viewmodel.dart';
import 'package:wan_android_flutter/widgets/my_button.dart';

import '../../route/route_path_constant.dart';
import '../../widgets/common_styles.dart';
import '../../widgets/dialog/update_dialog.dart';

/// 我的页面
class MinePage extends StatefulWidget {
  const MinePage({super.key});

  @override
  State<StatefulWidget> createState() => _MinePageState();
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
        backgroundColor: Colors.white,
        appBar: null,
        body: SafeArea(
          child: Column(
            children: [
              //  用户信息区域
              SizedBox(
                width: double.infinity,
                height: 200.h,
                child: Stack(
                  children: [
                    CachedNetworkImage(
                      cacheKey: DateTime.now.toString(),
                      fit: BoxFit.cover,
                      imageUrl: "https://picsum.photos/380/200",
                    ),
                    BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 6.0, sigmaY: 6.0),
                      child: const SizedBox(
                        width: double.infinity,
                        height: 200.0,
                      ),
                    ),
                    _userHeader(),
                  ],
                ),
              ),
              _commonItem(
                  title: "我的收藏",
                  onTap: () {
                    if (vm.shouldLogin == true) {
                      Get.toNamed(RoutePath.login);
                    } else {
                      Get.toNamed(RoutePath.myCollection);
                    }
                  }),
              Selector<MineViewModel, bool>(builder: (context, value, child) {
                return _commonItem(
                    showRedDot: value,
                    title: "检查更新",
                    onTap: () {
                      checkAppUpdate();
                    });
              }, selector: (context, vm) {
                return vm.needUpdate;
              }),

              _commonItem(
                  title: "关于我们",
                  onTap: () {
                    Get.toNamed(RoutePath.aboutUs);
                  }),

              const SizedBox(height: 100.0),

              _logoutButton(() {
                vm.logout();
              })
            ],
          ),
        ),
      ),
    );
  }

  Widget _userHeader() {
    return Container(
      width: double.infinity,
      height: 200.h,
      color: Colors.white10,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              log("点击头像或者用户名去登录");
              //  点击头像或者用户名
              if (vm.shouldLogin == true) {
                Get.toNamed(RoutePath.login);
              }
            },
            child: ClipOval(
              child: CachedNetworkImage(
                fit: BoxFit.cover,
                imageUrl: "https://picsum.photos/100/100",
              ),
            ),
          ),
          SizedBox(height: 5.h),
          Selector<MineViewModel, String?>(
            builder: (context, value, child) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                padding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 8.h),
                child: Text(value ?? "", style: whiteTextStyle15),
              );
            },
            selector: (context, value) {
              return value.userName;
            },
          )
        ],
      ),
    );
  }

  Widget _commonItem({
    required String title,
    GestureTapCallback? onTap,
    bool? showRedDot,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      width: double.infinity,
      child: Card(
        elevation: 1,
        color: Colors.white,
        child: InkWell(
          customBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 16.h),
            child: Row(
              children: [
                //  不显示红点需要填充一个边距
                if (showRedDot != true) SizedBox(width: 10.w),
                //  显示红点
                if (showRedDot == true)
                  Container(
                    margin: EdgeInsets.only(left: 3.w, right: 4.w),
                    width: 3.r,
                    height: 3.r,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.all(
                        Radius.circular(1.5.r),
                      ),
                    ),
                  ),
                Expanded(child: Text(title, style: blackTextStyle13)),
                Image.asset(
                  "assets/images/img_arrow_right.png",
                  width: 20.w,
                  height: 20.h,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 退出登录按钮
  Widget _logoutButton(GestureTapCallback? onTap) {
    return Selector<MineViewModel, bool>(builder: (context, value, child) {
      return !value
          ? Padding(
              padding: const EdgeInsets.only(left: 40, right: 40), // 四周都有4像素边距
              child: MyButton(
                key: const Key('logout'),
                onPressed: onTap,
                text: "退出登录",
              ),
            )
          : const SizedBox();
    }, selector: (context, m) {
      return m.shouldLogin ?? false;
    });
  }

  /// 检查更新
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
