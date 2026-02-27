import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wan_android_flutter/pages/about/about_us_viewmodel.dart';

import '../../widgets/my_app_bar.dart';

class AboutUsPage extends GetView<AboutUsViewModel> {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: const MyAppBar(
        centerTitle: "关于我们",
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
                            Icons.bookmark,
                            size: 90.r,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(height: 30.h),
                      // 应用名称
                      Text(
                        "玩安卓 Flutter",
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
                            "版本 ${controller.version}",
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
                        "持续学习中 · 努力提升中",
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
                      "应用功能",
                      style: TextStyle(
                        fontSize: 40.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 24.h),
                    // 功能列表
                    _buildFeatureItem(
                      icon: Icons.home,
                      title: "首页资讯",
                      description: "获取最新的安卓开发资讯和技术文章",
                    ),
                    SizedBox(height: 24.h),
                    _buildFeatureItem(
                      icon: Icons.book,
                      title: "知识体系",
                      description: "系统化学习安卓开发知识，构建完整知识体系",
                    ),
                    SizedBox(height: 24.h),
                    _buildFeatureItem(
                      icon: Icons.star,
                      title: "我的收藏",
                      description: "收藏喜欢的文章，方便随时查看和学习",
                    ),
                    SizedBox(height: 24.h),
                    _buildFeatureItem(
                      icon: Icons.person,
                      title: "个人中心",
                      description: "管理个人信息，查看学习记录和成就",
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
                      "开发者信息",
                      style: TextStyle(
                        fontSize: 40.sp,
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
                                "开发者",
                                style: TextStyle(
                                  fontSize: 32.sp,
                                  color: Colors.grey[600],
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                "今生挥毫只为你",
                                style: TextStyle(
                                  fontSize: 36.sp,
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
                      "其他信息",
                      style: TextStyle(
                        fontSize: 40.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 24.h),
                    _buildInfoItem(
                      icon: Icons.copyright,
                      title: "版权信息",
                      value: "© 2026 玩安卓 Flutter",
                    ),
                    SizedBox(height: 16.h),
                    _buildInfoItem(
                      icon: Icons.code,
                      title: "开源协议",
                      value: "MIT License",
                    ),
                    SizedBox(height: 16.h),
                    _buildInfoItem(
                      icon: Icons.update,
                      title: "检查更新",
                      value: "当前已是最新版本",
                    ),
                  ],
                ),
              ),

              SizedBox(height: 60.h),

              // 底部版权信息
              Column(
                children: [
                  Text(
                    "玩安卓 Flutter",
                    style: TextStyle(
                      fontSize: 32.sp,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    "持续学习 · 不断进步",
                    style: TextStyle(
                      fontSize: 28.sp,
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
                  fontSize: 36.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                description,
                style: TextStyle(
                  fontSize: 30.sp,
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
    return Row(
      children: [
        Icon(
          icon,
          size: 36.r,
          color: Colors.grey[500],
        ),
        SizedBox(width: 20.w),
        Text(
          value,
          style: TextStyle(
            fontSize: 32.sp,
            color: Colors.grey[700],
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
                fontSize: 32.sp,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 32.sp,
            color: Colors.blueAccent,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
