import 'dart:developer';

import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AboutUsViewModel extends GetxController {
  var version = "".obs;

  @override
  void onInit() {
    super.onInit();
    getVersion();
  }

  Future getVersion() async {
    var info = await PackageInfo.fromPlatform();
    version.value = info.version;
    log("getVersion : ${info.version}");
  }
}
