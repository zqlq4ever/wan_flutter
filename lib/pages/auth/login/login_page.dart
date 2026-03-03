import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wan_android_flutter/pages/auth/widgets/my_text_field.dart';
import 'package:wan_android_flutter/res/app_strings.dart';
import 'package:wan_android_flutter/res/colors.dart';
import 'package:wan_android_flutter/route/route_path_constant.dart';
import 'package:wan_android_flutter/utils/theme_util.dart';

import '../../../widgets/my_app_bar.dart';
import '../../../widgets/my_button.dart';
import 'login_viewmodel.dart';

/// 登录页面
///
/// 用户登录入口
/// 功能：
/// - 用户名输入：最大长度20字符
/// - 密码输入：支持密码显示/隐藏切换
/// - 登录按钮：点击执行登录操作
/// - 注册入口：跳转注册页面
class LoginPage extends GetView<LoginViewModel> {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    return WillPopScope(
      onWillPop: () async {
        // 返回时隐藏键盘
        FocusManager.instance.primaryFocus?.unfocus();
        return true;
      },
      child: Scaffold(
        backgroundColor: isDark ? Colours.dark_bg_color : Colors.white,
        appBar: MyAppBar(
          centerTitle: AppStrings.getString('login'),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 30.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 应用图标
                Container(
                  margin: EdgeInsets.only(top: 40.h, bottom: 50.h),
                  width: 180.r,
                  height: 180.r,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.blueAccent,
                        Colors.purpleAccent,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(45.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blueAccent.withValues(alpha: 0.3),
                        blurRadius: 30,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Icon(
                      Icons.person,
                      size: 90.r,
                      color: Colors.white,
                    ),
                  ),
                ),

                // 登录表单
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(30.w),
                  decoration: BoxDecoration(
                    color: isDark ? Colours.dark_card_bg : Colors.white,
                    borderRadius: BorderRadius.circular(24.r),
                    boxShadow: [
                      BoxShadow(
                        color:
                            Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 用户名输入框
                      MyTextField(
                        key: const Key('username'),
                        focusNode: controller.nodeText1,
                        controller: controller.nameController,
                        maxLength: 20,
                        keyboardType: TextInputType.text,
                        hintText: AppStrings.getString('input_account_hint'),
                      ),

                      SizedBox(height: 30.h),

                      // 密码输入框
                      MyTextField(
                        key: const Key('password'),
                        keyName: 'password',
                        focusNode: controller.nodeText2,
                        isInputPwd: true,
                        controller: controller.passwordController,
                        keyboardType: TextInputType.visiblePassword,
                        hintText: AppStrings.getString('input_password_hint'),
                      ),

                      SizedBox(height: 40.h),

                      // 登录按钮
                      MyButton(
                        key: const Key('login'),
                        onPressed: () {
                          // 登录前隐藏键盘
                          FocusManager.instance.primaryFocus?.unfocus();
                          controller.login();
                        },
                        text: AppStrings.getString('login'),
                        fontSize: 42.sp,
                        radius: 24.r,
                        minHeight: 96.h,
                        fontWeight: FontWeight.w600,
                      ),

                      SizedBox(height: 30.h),

                      // 注册链接
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            AppStrings.getString('no_account_hint'),
                            style: TextStyle(
                              fontSize: 36.sp,
                              color: isDark
                                  ? Colours.dark_text_gray
                                  : Colors.grey[600],
                            ),
                          ),
                          SizedBox(width: 8.w),
                          GestureDetector(
                            child: Text(
                              AppStrings.getString('register_now'),
                              key: const Key('noAccountRegister'),
                              style: TextStyle(
                                fontSize: 36.sp,
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            onTap: () {
                              // 跳转前隐藏键盘
                              FocusManager.instance.primaryFocus?.unfocus();
                              Get.toNamed(RoutePath.register);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 60.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
