import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:oktoast/oktoast.dart';
import 'package:wan_android_flutter/repository/api/wan_api.dart';
import 'package:wan_android_flutter/repository/model/user_info_model.dart';
import 'package:wan_android_flutter/route/route_path_constant.dart';
import 'package:wan_android_flutter/utils/sp_util.dart';

import '../../../constants.dart';


class LoginViewModel extends GetxController {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FocusNode nodeText1 = FocusNode();
  final FocusNode nodeText2 = FocusNode();
  var clickable = false.obs;

  String get inputUserName => nameController.text;

  String get inputPassword => passwordController.text;

  @override
  void onInit() {
    super.onInit();
    nameController.addListener(_verify);
    passwordController.addListener(_verify);
  }


  @override
  void onClose() {
    nameController.dispose();
    passwordController.dispose();
  }

  void _verify() {
    final String name = nameController.text;
    final String password = passwordController.text;
    bool _clickable = true;
    if (name.isEmpty || name.length > 20) {
      _clickable = false;
    }
    if (password.isEmpty || password.length < 6) {
      _clickable = false;
    }

    /// 状态不一样再刷新，避免不必要的 setState
    if (_clickable != clickable.value) {
      clickable.value = _clickable;
    }
  }

  Future<bool> login() async {
    UserInfoModel? userInfo = await WanApi.instance.login(inputUserName, inputPassword);
    if (userInfo?.username != null) {
      SpUtil.saveString(Constants.spUserName, userInfo?.username ?? "");
      Get.offAllNamed(RoutePath.tab);
      return true;
    } else {
      showToast("登录异常");
      return false;
    }
  }
}
