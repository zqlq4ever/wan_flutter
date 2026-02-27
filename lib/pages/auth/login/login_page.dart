import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wan_android_flutter/pages/auth/widgets/my_text_field.dart';
import 'package:wan_android_flutter/route/route_path_constant.dart';

import '../../../widgets/my_app_bar.dart';
import '../../../widgets/my_button.dart';
import 'login_viewmodel.dart';

//  登录页面
class LoginPage extends GetView<LoginViewModel> {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const MyAppBar(
        centerTitle: "登录",
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
                  Icons.lock,
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
                      hintText: "请输入您的密码",
                    ),
                    
                    SizedBox(height: 40.h),
                    
                    // 登录按钮
                    MyButton(
                      key: const Key('login'),
                      onPressed: () => controller.login(),
                      text: "登录",
                      fontSize: 36.sp,
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
                          "还没有账号？",
                          style: TextStyle(
                            fontSize: 30.sp,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(width: 8.w),
                        GestureDetector(
                          child: Text(
                            "立即注册",
                            key: const Key('noAccountRegister'),
                            style: TextStyle(
                              fontSize: 30.sp,
                              color: Colors.blueAccent,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          onTap: () => Get.toNamed(RoutePath.register),
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
    );
  }
}
