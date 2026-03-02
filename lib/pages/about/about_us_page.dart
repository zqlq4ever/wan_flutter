import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wan_android_flutter/pages/about/about_us_viewmodel.dart';
import 'package:wan_android_flutter/res/app_strings.dart';

import '../../widgets/my_app_bar.dart';
import '../../widgets/web/webview_page.dart';
import '../../widgets/web/webview_widget.dart';

class AboutUsPage extends GetView<AboutUsViewModel> {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: MyAppBar(
        centerTitle: AppStrings.getString('about_us'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 头部区域 - 应用信息
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30.r),
                    bottomRight: Radius.circular(30.r),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 60.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // 应用图标
                      Container(
                        width: 180.r,
                        height: 180.r,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.blueAccent.withValues(alpha: 0.8),
                              Colors.purpleAccent.withValues(alpha: 0.8),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(36.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blueAccent.withValues(alpha: 0.3),
                              blurRadius: 24,
                              offset: const Offset(0, 12),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Icon(
                            Icons.flutter_dash,
                            size: 100.r,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(height: 30.h),
                      // 应用名称
                      Text(
                        AppStrings.getString('app_full_name'),
                        style: TextStyle(
                          fontSize: 48.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      // 版本信息
                      Obx(() {
                        return Container(
                          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Text(
                            "${AppStrings.getString('version')} ${controller.version}",
                            style: TextStyle(
                              fontSize: 32.sp,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      }),
                      SizedBox(height: 16.h),
                      // 应用描述
                      Text(
                        AppStrings.getString('app_description'),
                        style: TextStyle(
                          fontSize: 32.sp,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 40.h),

              // 功能介绍区域
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 40.h),
                margin: EdgeInsets.symmetric(horizontal: 24.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.getString('app_features'),
                      style: TextStyle(
                        fontSize: 45.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 24.h),
                    // 功能列表
                    _buildFeatureItem(
                      icon: Icons.home,
                      title: AppStrings.getString('feature_home_title'),
                      description: AppStrings.getString('feature_home_desc'),
                    ),
                    SizedBox(height: 24.h),
                    _buildFeatureItem(
                      icon: Icons.book,
                      title: AppStrings.getString('feature_knowledge_title'),
                      description: AppStrings.getString('feature_knowledge_desc'),
                    ),
                    SizedBox(height: 24.h),
                    _buildFeatureItem(
                      icon: Icons.star,
                      title: AppStrings.getString('my_collection'),
                      description: AppStrings.getString('feature_collection_desc'),
                    ),
                    SizedBox(height: 24.h),
                    _buildFeatureItem(
                      icon: Icons.person,
                      title: AppStrings.getString('feature_profile_title'),
                      description: AppStrings.getString('feature_profile_desc'),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 32.h),

              // 开发者信息区域
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 40.h),
                margin: EdgeInsets.symmetric(horizontal: 24.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.getString('developer_info'),
                      style: TextStyle(
                        fontSize: 45.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 24.h),
                    Row(
                      children: [
                        Container(
                          width: 80.r,
                          height: 80.r,
                          decoration: BoxDecoration(
                            color: Colors.blueAccent.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.person,
                              size: 48.r,
                              color: Colors.blueAccent,
                            ),
                          ),
                        ),
                        SizedBox(width: 24.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppStrings.getString('developer'),
                                style: TextStyle(
                                  fontSize: 37.sp,
                                  color: Colors.grey[600],
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                AppStrings.getString('developer_name'),
                                style: TextStyle(
                                  fontSize: 41.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 24.h),
                    // 联系方式
                    _buildContactItem(
                      icon: Icons.email,
                      value: "zqlq4ever@163.com",
                    ),
                    SizedBox(height: 16.h),
                    _buildContactItem(
                      icon: Icons.link,
                      value: "https://github.com/zqlq4ever",
                    ),
                  ],
                ),
              ),

              SizedBox(height: 32.h),

              // 其他信息区域
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 40.h),
                margin: EdgeInsets.symmetric(horizontal: 24.w, vertical: 0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.getString('other_info'),
                      style: TextStyle(
                        fontSize: 45.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 24.h),
                    _buildInfoItem(
                      icon: Icons.copyright,
                      title: AppStrings.getString('copyright_info'),
                      value: AppStrings.getString('copyright_value'),
                    ),
                    SizedBox(height: 16.h),
                    _buildInfoItem(
                      icon: Icons.code,
                      title: AppStrings.getString('open_source_license'),
                      value: AppStrings.getString('mit_license'),
                    ),
                    SizedBox(height: 16.h),
                    _buildInfoItem(
                      icon: Icons.update,
                      title: AppStrings.getString('check_update'),
                      value: AppStrings.getString('current_latest_version'),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 60.h),

              // 底部版权信息
              Column(
                children: [
                  Text(
                    AppStrings.getString('app_full_name'),
                    style: TextStyle(
                      fontSize: 37.sp,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    AppStrings.getString('keep_learning'),
                    style: TextStyle(
                      fontSize: 33.sp,
                      color: Colors.grey[500],
                    ),
                  ),
                  SizedBox(height: 40.h),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 功能项构建方法
  Widget _buildFeatureItem({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 60.r,
          height: 60.r,
          decoration: BoxDecoration(
            color: Colors.blueAccent.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Center(
            child: Icon(
              icon,
              size: 36.r,
              color: Colors.blueAccent,
            ),
          ),
        ),
        SizedBox(width: 20.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 41.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                description,
                style: TextStyle(
                  fontSize: 35.sp,
                  color: Colors.grey[600],
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // 联系项构建方法
  Widget _buildContactItem({
    required IconData icon,
    required String value,
  }) {
    final isLink = value.startsWith('http');
    return Row(
      children: [
        Icon(
          icon,
          size: 36.r,
          color: Colors.grey[500],
        ),
        SizedBox(width: 20.w),
        Expanded(
          child: GestureDetector(
            onTap: isLink
                ? () {
                    Get.to(
                      WebViewPage(
                        loadResource: value,
                        webViewType: WebViewType.URL,
                        title: value,
                      ),
                    );
                  }
                : null,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 37.sp,
                color: isLink ? Colors.blueAccent : Colors.grey[700],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // 信息项构建方法
  Widget _buildInfoItem({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 36.r,
              color: Colors.grey[500],
            ),
            SizedBox(width: 16.w),
            Text(
              title,
              style: TextStyle(
                fontSize: 37.sp,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 37.sp,
            color: Colors.blueAccent,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
