import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wan_android_flutter/pages/auth/register_viewmodel.dart';
import 'package:wan_android_flutter/pages/auth/widgets/my_text_field.dart';

import '../../res/gaps.dart';
import '../../utils/other_utils.dart';
import '../../widgets/my_app_bar.dart';
import '../../widgets/my_button.dart';
import '../../widgets/my_scroll_view.dart';

/// design/1注册登录/index.html#artboard11
class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});

  var vm = Get.put(RegisterViewModel());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(
        centerTitle: "注册",
      ),
      body: MyScrollView(
        keyboardConfig: Utils.getKeyboardActionsConfig(context, <FocusNode>[vm.nodeText1, vm.nodeText2, vm.nodeText3]),
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
        focusNode: vm.nodeText1,
        controller: vm.nameController,
        maxLength: 20,
        keyboardType: TextInputType.text,
        hintText: "输入账号",
      ),
      Gaps.vGap8,
      MyTextField(
        key: const Key('password'),
        keyName: 'password',
        focusNode: vm.nodeText2,
        isInputPwd: true,
        controller: vm.passwordController,
        keyboardType: TextInputType.visiblePassword,
        hintText: '输入密码',
      ),
      Gaps.vGap8,
      MyTextField(
        key: const Key('password2'),
        keyName: 'password2',
        focusNode: vm.nodeText3,
        isInputPwd: true,
        controller: vm.password2Controller,
        keyboardType: TextInputType.visiblePassword,
        hintText: '再次输入密码',
      ),
      Gaps.vGap24,
      MyButton(
        key: const Key('register'),
        onPressed: () => vm.register(),
        text: "注册",
      )
    ];
  }
}
