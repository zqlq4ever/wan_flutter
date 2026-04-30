import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';

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
    _loadData();
  }

  Future<void> _loadData() async {
    await Future.wait([
      _loadVersion(),
      _loadCacheSize(),
    ]);
  }

  Future<void> _loadVersion() async {
    try {
      final info = await PackageInfo.fromPlatform();
      _version.value = info.version;
    } catch (_) {
      _version.value = '...';
    }
  }

  Future<void> _loadCacheSize() async {
    // Web 没有可靠的文件系统 cache 目录，这里做降级展示
    _cacheSize.value = '0B';
  }

  Future<void> clearCache() async {
    // Web 降级：不做文件系统清理
    _cacheSize.value = '0B';
  }
}
