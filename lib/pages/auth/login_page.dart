import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:wan_android_flutter/pages/auth/auth_view_model.dart';
import 'package:wan_android_flutter/pages/auth/register_page.dart';
import 'package:wan_android_flutter/pages/tab_page.dart';
import 'package:wan_android_flutter/route/RouteUtils.dart';
import 'package:wan_android_flutter/widgets/common_styles.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  var vm = AuthViewModel();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        return vm;
      },
      child: Scaffold(
        backgroundColor: Colors.teal,
        body: SafeArea(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 15.w),
            alignment: Alignment.center,
            child: Expanded(
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                commonInputText(
                    labelText: '输入账号',
                    onChanged: (value) {
                      vm.inputUserName = value;
                    }),
                SizedBox(height: 15.h),
                commonInputText(
                    labelText: '输入密码',
                    obscureText: true,
                    onChanged: (value) {
                      vm.inputPassword = value;
                    }),
                SizedBox(height: 45.h),
                outlineWhiteButton("开始登录", onTap: () {
                  log("${vm.inputUserName}");
                  log("${vm.inputPassword}");
                  vm.login().then((value) {
                    if (value) {
                      RouteUtils.pushAndRemoveUntil(context, const BottomTabPage());
                    }
                  });
                }),
                SizedBox(height: 15.h),
                GestureDetector(
                    onTap: () {
                      //点击进入到注册页面
                      RouteUtils.push(context, const RegisterPage());
                    },
                    child: Text("注册", style: whiteTextStyle15))
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
