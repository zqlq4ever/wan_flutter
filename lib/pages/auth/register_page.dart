import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

import '../../widgets/common_styles.dart';
import 'auth_view_model.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _RegisterPageState();
  }
}

class _RegisterPageState extends State<RegisterPage> {
  late BuildContext _context;
  var model = AuthViewModel();

  @override
  Widget build(BuildContext context) {
    _context = context;
    // 在 build 方法中设置状态栏颜色
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.light, // 状态栏图标亮度，dark表示黑色图标，light表示白色图标
    ));
    return ChangeNotifierProvider(
      create: (context) {
        return model;
      },
      child: Scaffold(
        backgroundColor: Colors.white10,
        body: SafeArea(
          child: Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 15.w),
              width: double.infinity,
              height: double.infinity,
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  commonInputText(
                      labelText: '输入账号',
                      onChanged: (value) {
                        model.inputUserName = value;
                      }),
                  SizedBox(height: 15.h),
                  commonInputText(
                      labelText: '输入密码',
                      obscureText: true,
                      onChanged: (value) {
                        model.inputPassword = value;
                      }),
                  SizedBox(height: 15.h),
                  commonInputText(
                      labelText: '再次输入密码',
                      obscureText: true,
                      onChanged: (value) {
                        model.inputPasswordTwice = value;
                      }),
                  SizedBox(height: 45.h),
                  outlineWhiteButton("点我注册", onTap: () {
                    model.register().then((value) {
                      if (value) {
                        Navigator.pop(_context);
                        showToast("注册成功");
                      } else {
                        showToast("注册失败");
                      }
                    });
                  })
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.dark,
    ));
  }
}
