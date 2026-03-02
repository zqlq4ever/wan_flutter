import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wan_android_flutter/app.dart';
import 'package:wan_android_flutter/network/dio_client.dart';
import 'package:wan_android_flutter/repository/url_path_contants.dart';

void main() async {
  String baseUrl = UrlPathConstants.hostWanandroid;
  if (kIsWeb) {
    baseUrl = '/api/';
  }
  DioClient.instance.init(baseUrl: baseUrl);
  await ScreenUtil.ensureScreenSize();
  runApp(const WanApp());
}
