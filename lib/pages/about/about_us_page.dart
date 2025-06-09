import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:package_info_plus/package_info_plus.dart';

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
      appBar: AppBar(title: const Text("关于我们")),
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 80.h),
                Image.asset("assets/images/ic_launcher.png", width: 100.w, height: 100.h),
                Text("v $_version"),
                // Html(
                //   data: "https://www.wanandroid.com/wxarticle/list/408/1",
                //   onLinkTap: (
                //     String? url,
                //     Map<String, String> attributes,
                //     element,
                //   ) {
                //     log("AboutUsPage html onLinkTap url= $url");
                //     //  进入网页
                //     RouteUtil.push(
                //       context,
                //       WebViewPage(
                //         loadResource: url ?? "",
                //         webViewType: WebViewType.URL,
                //         showTitle: true,
                //       ),
                //     );
                //   },
                // ),
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
