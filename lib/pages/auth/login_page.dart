import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wan_android_flutter/pages/auth/login_viewmodel.dart';
import 'package:wan_android_flutter/pages/auth/widgets/my_text_field.dart';
import 'package:wan_android_flutter/route/RoutePath.dart';
import 'package:wan_android_flutter/widgets/my_app_bar.dart';

import '../../res/gaps.dart';
import '../../utils/other_utils.dart';
import '../../widgets/my_button.dart';
import '../../widgets/my_scroll_view.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  var vm = Get.put(LoginViewModel());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(
        centerTitle: "密码登陆",
      ),
      body: MyScrollView(
        keyboardConfig: Utils.getKeyboardActionsConfig(context, <FocusNode>[vm.nodeText1, vm.nodeText2]),
        padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 20.0),
        children: _buildBody,
      ),
    );
  }

  List<Widget> get _buildBody => <Widget>[
        Gaps.vGap16,
        MyTextField(
          key: const Key('username'),
          focusNode: vm.nodeText1,
          controller: vm.nameController,
          maxLength: 20,
          keyboardType: TextInputType.text,
          hintText: "输入用户名",
        ),
        Gaps.vGap8,
        MyTextField(
          key: const Key('password'),
          keyName: 'password',
          focusNode: vm.nodeText2,
          isInputPwd: true,
          controller: vm.passwordController,
          keyboardType: TextInputType.visiblePassword,
          hintText: "输入密码",
        ),
        Gaps.vGap24,
        MyButton(
          key: const Key('login'),
          onPressed: () => vm.login(),
          text: "登录",
        ),
        Gaps.vGap16,
        Container(
          alignment: Alignment.center,
          child: GestureDetector(
            child: const Text(
              "注册账号",
              key: Key('noAccountRegister'),
            ),
            onTap: () => Get.toNamed(RoutePath.register),
          ),
        )
      ];
}
