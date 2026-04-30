import 'package:get/get.dart';

class SettingsViewModel extends GetxController {
  final _version = '...'.obs;
  String get version => _version.value;

  final _cacheSize = '...'.obs;
  String get cacheSize => _cacheSize.value;

  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  @override
  void onInit() {
    super.onInit();
    _version.value = '...';
    _cacheSize.value = '0B';
  }

  Future<void> clearCache() async {}
}
