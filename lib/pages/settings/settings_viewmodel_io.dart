import 'dart:io';

import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';

class SettingsViewModel extends GetxController {
  static const _cachePath = 'cache';

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

  Future<Directory> _cacheDirectory() async {
    final dir = await getTemporaryDirectory();
    return Directory('${dir.path}/$_cachePath');
  }

  Future<void> _loadCacheSize() async {
    try {
      final directory = await _cacheDirectory();
      if (await directory.exists()) {
        var totalSize = 0;
        await for (final entity in directory.list(recursive: true)) {
          if (entity is File) {
            totalSize += await entity.length();
          }
        }
        _cacheSize.value = formatBytes(totalSize);
      } else {
        _cacheSize.value = '0B';
      }
    } catch (_) {
      _cacheSize.value = '0B';
    }
  }

  Future<void> clearCache() async {
    _isLoading.value = true;
    try {
      final directory = await _cacheDirectory();
      if (await directory.exists()) {
        await for (final entity in directory.list(recursive: true)) {
          if (entity is File) {
            await entity.delete();
          }
        }
      }
      _cacheSize.value = '0B';
    } catch (_) {
      // ignore
    } finally {
      _isLoading.value = false;
    }
  }

  static String formatBytes(int bytes) {
    if (bytes < 1024) {
      return '$bytes B';
    } else if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    } else if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    } else {
      return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
    }
  }
}
