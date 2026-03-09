import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:oktoast/oktoast.dart';
import 'package:wan_android_flutter/repository/api/wan_api.dart';
import 'package:wan_android_flutter/repository/model/user_info_model.dart';
import 'package:wan_android_flutter/res/app_strings.dart';

class RegisterViewModel extends GetxController {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController password2Controller = TextEditingController();
  final FocusNode nodeText1 = FocusNode();
  final FocusNode nodeText2 = FocusNode();
  final FocusNode nodeText3 = FocusNode();
  
  final _clickable = false.obs;
  RxBool get clickable => _clickable;
  
  final _isLoading = false.obs;
  RxBool get isLoading => _isLoading;

  String get inputUserName => nameController.text;

  String get inputPassword => passwordController.text;

  String get inputPasswordTwice => password2Controller.text;

  @override
  void onInit() {
    super.onInit();
    nameController.addListener(_verify);
    passwordController.addListener(_verify);
    password2Controller.addListener(_verify);
  }

  @override
  void onClose() {
    nameController.dispose();
    passwordController.dispose();
    password2Controller.dispose();
    nodeText1.dispose();
    nodeText2.dispose();
    nodeText3.dispose();
    super.onClose();
  }

  void _verify() {
    final name = nameController.text;
    final password = passwordController.text;
    final password2 = password2Controller.text;
    
    final isValid = name.isNotEmpty && 
                    name.length <= 20 && 
                    password.isNotEmpty && 
                    password.length >= 6 &&
                    password2.isNotEmpty && 
                    password2.length >= 6;
    
    if (isValid != _clickable.value) {
      _clickable.value = isValid;
    }
  }

  Future<bool> register() async {
    if (_isLoading.value) return false;
    
    _isLoading.value = true;
    try {
      UserInfoModel? userInfo = await WanApi.instance.register(
        inputUserName,
        inputPassword,
        inputPasswordTwice,
      );
      if (userInfo?.username != null) {
        showToast(AppStrings.getString('register_success'));
        Get.back();
        return true;
      } else {
        showToast(AppStrings.getString('register_error'));
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
