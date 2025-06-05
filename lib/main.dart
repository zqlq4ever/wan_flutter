import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wan_android_flutter/app.dart';
import 'package:wan_android_flutter/network/dio_util.dart';
import 'package:wan_android_flutter/repository/url_path_contants.dart';

void main() async {
  DioInstance.instance.initDio(baseUrl: UrlPathConstants.hostWanandroid);
  await ScreenUtil.ensureScreenSize();
  runApp(const WanApp());
}
