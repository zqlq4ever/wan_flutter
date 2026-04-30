import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wan_android_flutter/app.dart';
import 'package:wan_android_flutter/network/dio_client.dart';
import 'package:wan_android_flutter/repository/url_path_contants.dart';
import 'package:wan_android_flutter/utils/sp_util.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  String baseUrl = UrlPathConstants.hostWanandroid;
  if (kIsWeb) {
    baseUrl = '/api/';
  }
  await SpUtil.init();
  DioClient.instance.init(baseUrl: baseUrl);
  await ScreenUtil.ensureScreenSize();
  runApp(const WanApp());
}
