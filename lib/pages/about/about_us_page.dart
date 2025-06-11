import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../widgets/my_app_bar.dart';

class AboutUsPage extends StatefulWidget {
  const AboutUsPage({super.key});

  @override
  State createState() {
    return _AboutUsPageState();
  }
}

class _AboutUsPageState extends State<AboutUsPage> {
  String? _version = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      getVersion();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const MyAppBar(
        centerTitle: "关于我们",
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 50.h),
                const FlutterLogo(
                  size: 100,
                  style: FlutterLogoStyle.markOnly, // 可选样式: stacked, markOnly
                  curve: Curves.easeInOut, // 动画曲线
                  duration: Duration(seconds: 1), // 旋转动画时长
                ),
                SizedBox(height: 20.h),
                Text("v $_version - 持续学习中 ~"),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future getVersion() async {
    var info = await PackageInfo.fromPlatform();
    _version = info.version;
    setState(() {});
  }
}
