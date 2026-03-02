import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wan_android_flutter/pages/auth/widgets/my_text_field.dart';
import 'package:wan_android_flutter/res/app_strings.dart';
import 'package:wan_android_flutter/res/colors.dart';
import 'package:wan_android_flutter/utils/theme_util.dart';

import '../../../widgets/my_app_bar.dart';
import '../../../widgets/my_button.dart';
import 'register_viewmodel.dart';

/// 账号注册页面
///
/// 新用户注册入口
/// 功能：
/// - 用户名输入：最大长度20字符
/// - 密码输入：支持密码显示/隐藏切换
/// - 确认密码：二次确认密码
/// - 注册按钮：点击执行注册操作
class RegisterPage extends GetView<RegisterViewModel> {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    return Scaffold(
      backgroundColor: isDark ? Colours.dark_bg_color : Colors.white,
      appBar: MyAppBar(
        centerTitle: AppStrings.getString('register'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 30.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(top: 40.h, bottom: 50.h),
                width: 180.r,
                height: 180.r,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.greenAccent,
                      Colors.blueAccent,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(45.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.greenAccent.withValues(alpha: 0.3),
                      blurRadius: 30,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(
                    Icons.person_add,
                    size: 90.r,
                    color: Colors.white,
                  ),
                ),
              ),
              
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(30.w),
                decoration: BoxDecoration(
                  color: isDark ? Colours.dark_card_bg : Colors.white,
                  borderRadius: BorderRadius.circular(30.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.08),
                      blurRadius: 20,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.getString('account'),
                      style: TextStyle(
                        fontSize: 32.sp,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colours.dark_text : Colors.black87,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    MyTextField(
                      key: const Key('username'),
                      focusNode: controller.nodeText1,
                      controller: controller.nameController,
                      maxLength: 20,
                      keyboardType: TextInputType.text,
                      hintText: AppStrings.getString('input_account_hint'),
                    ),
                    
                    SizedBox(height: 30.h),
                    
                    Text(
                      AppStrings.getString('password'),
                      style: TextStyle(
                        fontSize: 32.sp,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colours.dark_text : Colors.black87,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    MyTextField(
                      key: const Key('password'),
                      keyName: 'password',
                      focusNode: controller.nodeText2,
                      isInputPwd: true,
                      controller: controller.passwordController,
                      keyboardType: TextInputType.visiblePassword,
                      hintText: AppStrings.getString('input_password_hint'),
                    ),
                    
                    SizedBox(height: 30.h),
                    
                    Text(
                      AppStrings.getString('confirm_password'),
                      style: TextStyle(
                        fontSize: 32.sp,
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colours.dark_text : Colors.black87,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    MyTextField(
                      key: const Key('password2'),
                      keyName: 'password2',
                      focusNode: controller.nodeText3,
                      isInputPwd: true,
                      controller: controller.password2Controller,
                      keyboardType: TextInputType.visiblePassword,
                      hintText: AppStrings.getString('input_password_again_hint'),
                    ),
                    
                    SizedBox(height: 40.h),
                    
                    MyButton(
                      key: const Key('register'),
                      onPressed: () => controller.register(),
                      text: AppStrings.getString('register'),
                      fontSize: 36.sp,
                      radius: 24.r,
                      minHeight: 96.h,
                      fontWeight: FontWeight.w600,
                    ),
                    
                    SizedBox(height: 60.h),
                  ],
                ),
              ),
              
              SizedBox(height: 60.h),
            ],
          ),
        ),
      ),
    );
  }
}
