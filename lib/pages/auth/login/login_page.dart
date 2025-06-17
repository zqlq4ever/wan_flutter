import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wan_android_flutter/pages/auth/widgets/my_text_field.dart';
import 'package:wan_android_flutter/route/route_path_constant.dart';
import 'package:wan_android_flutter/widgets/my_app_bar.dart';

import '../../../res/gaps.dart';
import '../../../utils/other_utils.dart';
import '../../../widgets/my_button.dart';
import '../../../widgets/my_scroll_view.dart';
import 'login_viewmodel.dart';

//  登录页面
class LoginPage extends GetView<LoginViewModel> {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const MyAppBar(
        centerTitle: "密码登录",
      ),
      body: MyScrollView(
        keyboardConfig: Utils.getKeyboardActionsConfig(
          context,
          <FocusNode>[
            controller.nodeText1,
            controller.nodeText2,
          ],
        ),
        padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 20.0),
        children: _buildBody,
      ),
    );
  }

  List<Widget> get _buildBody => <Widget>[
        Gaps.vGap16,
        MyTextField(
          key: const Key('username'),
          focusNode: controller.nodeText1,
          controller: controller.nameController,
          maxLength: 20,
          keyboardType: TextInputType.text,
          hintText: "输入账号",
        ),
        Gaps.vGap8,
        MyTextField(
          key: const Key('password'),
          keyName: 'password',
          focusNode: controller.nodeText2,
          isInputPwd: true,
          controller: controller.passwordController,
          keyboardType: TextInputType.visiblePassword,
          hintText: "输入密码",
        ),
        Gaps.vGap24,
        MyButton(
          key: const Key('login'),
          onPressed: () => controller.login(),
          text: "登录",
        ),
        Gaps.vGap32,
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
