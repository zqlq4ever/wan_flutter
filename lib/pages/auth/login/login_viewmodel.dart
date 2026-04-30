import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:oktoast/oktoast.dart';
import 'package:wan_android_flutter/repository/api/wan_api.dart';
import 'package:wan_android_flutter/repository/model/user_info_model.dart';
import 'package:wan_android_flutter/res/app_strings.dart';
import 'package:wan_android_flutter/route/route_path_constant.dart';
import 'package:wan_android_flutter/utils/sp_util.dart';

import '../../../constants.dart';

class LoginViewModel extends GetxController {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FocusNode nodeText1 = FocusNode();
  final FocusNode nodeText2 = FocusNode();

  final _clickable = false.obs;
  RxBool get clickable => _clickable;

  final _isLoading = false.obs;
  RxBool get isLoading => _isLoading;

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
    nodeText1.dispose();
    nodeText2.dispose();
    super.onClose();
  }

  void _verify() {
    final name = nameController.text;
    final password = passwordController.text;

    final isValid = name.isNotEmpty &&
        name.length <= 20 &&
        password.isNotEmpty &&
        password.length >= 6;

    if (isValid != _clickable.value) {
      _clickable.value = isValid;
    }
  }

  Future<bool> login() async {
    if (_isLoading.value) return false;

    _isLoading.value = true;
    try {
      UserInfoModel? userInfo =
          await WanApi.instance.login(inputUserName, inputPassword);
      if (userInfo?.username != null) {
        SpUtil.saveString(Constants.spUserName, userInfo?.username ?? "");
        Get.offAllNamed(RoutePath.tab);
        return true;
      } else {
        showToast(AppStrings.getString('login_error'));
        return false;
      }
    } catch (e) {
      showToast(AppStrings.getString('network_error'));
      return false;
    } finally {
      _isLoading.value = false;
    }
  }
}
