import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wan_android_flutter/pages/auth/widgets/my_text_field.dart';

import '../../../widgets/my_app_bar.dart';
import '../../../widgets/my_button.dart';
import 'register_viewmodel.dart';

/// 账号注册页面
class RegisterPage extends GetView<RegisterViewModel> {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const MyAppBar(
        centerTitle: "注册",
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
              
              // 注册表单
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(30.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 20,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 用户名输入框
                    Text(
                      "账号",
                      style: TextStyle(
                        fontSize: 32.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    MyTextField(
                      key: const Key('username'),
                      focusNode: controller.nodeText1,
                      controller: controller.nameController,
                      maxLength: 20,
                      keyboardType: TextInputType.text,
                      hintText: "请输入您的账号",
                    ),
                    
                    SizedBox(height: 30.h),
                    
                    // 密码输入框
                    Text(
                      "密码",
                      style: TextStyle(
                        fontSize: 32.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
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
                      hintText: '请输入您的密码',
                    ),
                    
                    SizedBox(height: 30.h),
                    
                    // 确认密码输入框
                    Text(
                      "确认密码",
                      style: TextStyle(
                        fontSize: 32.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
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
                      hintText: '请再次输入密码',
                    ),
                    
                    SizedBox(height: 40.h),
                    
                    // 注册按钮
                    MyButton(
                      key: const Key('register'),
                      onPressed: () => controller.register(),
                      text: "注册",
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
