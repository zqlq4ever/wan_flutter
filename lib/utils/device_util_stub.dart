import 'package:flutter/foundation.dart';

class Device {
  static bool get isDesktop => false;
  static bool get isMobile => false;
  static bool get isWeb => kIsWeb;

  static bool get isWindows => false;
  static bool get isLinux => false;
  static bool get isMacOS => false;
  static bool get isAndroid => false;
  static bool get isFuchsia => false;
  static bool get isIOS => false;

  static Future<void> initDeviceInfo() async {}

  static int getAndroidSdkInt() => -1;
}
