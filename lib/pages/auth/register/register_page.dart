import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wan_android_flutter/pages/auth/register/register_viewmodel.dart';
import 'package:wan_android_flutter/pages/auth/widgets/my_text_field.dart';

import '../../../res/gaps.dart';
import '../../../utils/other_utils.dart';
import '../../../widgets/my_app_bar.dart';
import '../../../widgets/my_button.dart';
import '../../../widgets/my_scroll_view.dart';

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
      body: MyScrollView(
        keyboardConfig: Utils.getKeyboardActionsConfig(
            context, <FocusNode>[controller.nodeText1, controller.nodeText2, controller.nodeText3]),
        crossAxisAlignment: CrossAxisAlignment.center,
        padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 20.0),
        children: _buildBody(),
      ),
    );
  }

  List<Widget> _buildBody() {
    return <Widget>[
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
        hintText: '输入密码',
      ),
      Gaps.vGap8,
      MyTextField(
        key: const Key('password2'),
        keyName: 'password2',
        focusNode: controller.nodeText3,
        isInputPwd: true,
        controller: controller.password2Controller,
        keyboardType: TextInputType.visiblePassword,
        hintText: '再次输入密码',
      ),
      Gaps.vGap24,
      MyButton(
        key: const Key('register'),
        onPressed: () => controller.register(),
        text: "注册",
      )
    ];
  }
}
