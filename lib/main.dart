import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wan_android_flutter/app.dart';
import 'package:wan_android_flutter/network/dio_util.dart';
import 'package:wan_android_flutter/repository/url_path_contants.dart';

void main() async {
  // 根据平台设置不同的baseUrl
  String baseUrl = UrlPathConstants.hostWanandroid;
  // Web平台使用代理路径
  if (kIsWeb) {
    baseUrl = '/api/';
  }
  DioInstance.instance.initDio(baseUrl: baseUrl);
  await ScreenUtil.ensureScreenSize();
  runApp(const WanApp());
}
