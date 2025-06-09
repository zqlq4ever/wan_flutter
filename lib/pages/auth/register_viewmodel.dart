import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:oktoast/oktoast.dart';
import 'package:wan_android_flutter/repository/api/wan_api.dart';
import 'package:wan_android_flutter/repository/model/user_info_model.dart';
import 'package:wan_android_flutter/route/RoutePath.dart';

class RegisterViewModel extends GetxController {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController password2Controller = TextEditingController();
  final FocusNode nodeText1 = FocusNode();
  final FocusNode nodeText2 = FocusNode();
  final FocusNode nodeText3 = FocusNode();
  var clickable = false.obs;

  String? get inputUserName => nameController.text;

  String? get inputPassword => passwordController.text;

  String? get inputPasswordTwice => password2Controller.text;

  @override
  void onInit() {
    super.onInit();
    nameController.addListener(_verify);
    passwordController.addListener(_verify);
    password2Controller.addListener(_verify);
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    passwordController.dispose();
    password2Controller.dispose();
  }

  void _verify() {
    final String name = nameController.text;
    final String password = passwordController.text;
    final String password2 = password2Controller.text;
    bool _clickable = true;
    if (name.isEmpty || name.length > 20) {
      _clickable = false;
    }
    if (password.isEmpty || password.length < 6) {
      _clickable = false;
    }
    if (password2.isEmpty || password2.length < 6) {
      _clickable = false;
    }

    /// 状态不一样再刷新，避免不必要的 setState
    if (_clickable != clickable.value) {
      clickable.value = _clickable;
    }
  }

  Future<bool> register() async {
    UserInfoModel? userInfo = await WanApi.instance.register(
      inputUserName,
      inputPassword,
      inputPasswordTwice,
    );
    if (userInfo?.username != null) {
      showToast("注册成功,开始登录吧~");
      Get.back();
      return true;
    } else {
      showToast("注册异常");
      return false;
    }
  }
}
