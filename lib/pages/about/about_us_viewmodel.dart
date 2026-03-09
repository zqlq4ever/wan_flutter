import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AboutUsViewModel extends GetxController {
  final _version = "".obs;
  String get version => _version.value;

  @override
  void onInit() {
    super.onInit();
    getVersion();
  }

  Future<void> getVersion() async {
    try {
      final info = await PackageInfo.fromPlatform();
      _version.value = info.version;
    } catch (e) {
      _version.value = "";
    }
  }
}
