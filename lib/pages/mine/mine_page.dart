import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:wan_android_flutter/pages/mine/mine_view_model.dart';
import 'package:wan_android_flutter/widgets/my_button.dart';

import '../../route/RoutePath.dart';
import '../../widgets/common_styles.dart';
import '../../widgets/dialog/update_dialog.dart';

/// 我的页面
class MineNewPage extends StatefulWidget {
  const MineNewPage({super.key});

  @override
  State<StatefulWidget> createState() => _MineNewPageState();
}

class _MineNewPageState extends State<MineNewPage> {
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
              _userArea(
                children: _userHead(onTap: () {
                  //  点击头像或者用户名
                  if (vm.shouldLogin == true) {
                    log("点击头像或者用户名去登录");
                    Get.toNamed(RoutePath.login);
                  }
                }),
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

  Widget _userArea({required List<Widget> children}) {
    return Container(
      width: double.infinity,
      height: 200.h,
      color: Colors.white10,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: children,
      ),
    );
  }

  List<Widget> _userHead({
    GestureTapCallback? onTap,
  }) {
    return [
      GestureDetector(
        onTap: onTap,
        child: ClipOval(
          child: Image.network(
            "https://picsum.photos/100",
            width: 100,
            height: 100,
            fit: BoxFit.cover,
          ),
        ),
      ),
      SizedBox(height: 5.h),
      GestureDetector(
        onTap: onTap,
        child: Selector<MineViewModel, String?>(
          builder: (context, value, child) {
            return Text(value ?? "", style: titleTextStyle15);
          },
          selector: (context, value) {
            return value.userName;
          },
        ),
      )
    ];
  }

  Widget _commonItem({required String title, GestureTapCallback? onTap, bool? showRedDot}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.only(right: 5.w),
        margin: EdgeInsets.only(left: 15.w, right: 15.w, top: 10.h),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black38, width: 0.5.r),
          borderRadius: BorderRadius.all(Radius.circular(5.r)),
        ),
        width: double.infinity,
        height: 45.h,
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
                decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.all(Radius.circular(1.5.r))),
              ),
            Expanded(child: Text(title, style: blackTextStyle13)),
            Image.asset("assets/images/img_arrow_right.png", width: 20.r, height: 20.r)
          ],
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
