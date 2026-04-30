import 'package:get/get.dart';
import 'package:oktoast/oktoast.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wan_android_flutter/constants.dart';
import 'package:wan_android_flutter/repository/api/wan_api.dart';
import 'package:wan_android_flutter/res/app_strings.dart';
import 'package:wan_android_flutter/utils/sp_util.dart';

class MineViewModel extends GetxController {
  final _userName = Rxn<String>();
  final _shouldLogin = true.obs;
  final _needUpdate = false.obs;
  final _isLoading = false.obs;

  String? get userName => _userName.value;

  bool get shouldLogin => _shouldLogin.value;

  bool get needUpdate => _needUpdate.value;

  bool get isLoading => _isLoading.value;

  @override
  void onInit() {
    super.onInit();
    initData();
  }

  Future<void> initData() async {
    _isLoading.value = true;
    try {
      final name = await SpUtil.getString(Constants.spUserName);
      _userName.value = (name?.isNotEmpty == true) ? name : null;
      _shouldLogin.value = _userName.value == null;
      await _checkUpdateDot();
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> logout() async {
    try {
      final success = await WanApi.instance.logout();
      if (success) {
        _userName.value = null;
        _shouldLogin.value = true;
        await Future.wait([
          SpUtil.remove(Constants.spUserName),
          SpUtil.remove(Constants.spCookieList),
        ]);
      } else {
        showToast(AppStrings.getString('network_error'));
      }
    } catch (e) {
      showToast(AppStrings.getString('network_error'));
    }
  }

  Future<void> _checkUpdateDot() async {
    try {
      final packInfo = await PackageInfo.fromPlatform();
      final currentVersion = int.tryParse(packInfo.buildNumber) ?? 0;
      final newVersion = int.tryParse(
              await SpUtil.getString(Constants.spNewAppVersion) ?? "0") ??
          0;
      _needUpdate.value = currentVersion < newVersion;
    } catch (e) {
      _needUpdate.value = false;
    }
  }

  Future<String?> checkUpdate() async {
    try {
      final packInfo = await PackageInfo.fromPlatform();
      final currentVersion = int.tryParse(packInfo.buildNumber) ?? 0;
      final model = await WanApi.instance.checkUpdate();
      final onlineVersion =
          int.tryParse(model?.data?.buildVersionNo ?? "0") ?? 0;

      if (currentVersion < onlineVersion) {
        await SpUtil.saveString(
            Constants.spNewAppVersion, model?.data?.buildVersionNo ?? "");
        return model?.data?.downloadURL;
      }
      await SpUtil.saveString(Constants.spNewAppVersion, packInfo.buildNumber);
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<bool> openUrl(String? url) async {
    if (url == null || url.isEmpty) return false;
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      return launchUrl(uri);
    }
    return false;
  }
}
