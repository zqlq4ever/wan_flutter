import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wan_android_flutter/res/colors.dart';
import 'package:wan_android_flutter/widgets/web/webview_page.dart';
import 'package:wan_android_flutter/widgets/web/webview_widget.dart';

class UpdateDialog extends StatefulWidget {
  const UpdateDialog({super.key});

  @override
  _UpdateDialogState createState() => _UpdateDialogState();
}

class _UpdateDialogState extends State<UpdateDialog> {
  final CancelToken _cancelToken = CancelToken();
  double _value = 0;

  @override
  void dispose() {
    if (!_cancelToken.isCancelled && _value != 1) {
      _cancelToken.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.black54,
        body: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            constraints: BoxConstraints(maxWidth: 700.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(40.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 30,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildHeader(),
                _buildContent(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 50.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40.r),
          topRight: Radius.circular(40.r),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 120.r,
            height: 120.r,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colours.app_main.withValues(alpha: 0.15),
                  Colours.app_main.withValues(alpha: 0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(30.r),
            ),
            child: Icon(
              Icons.system_update_alt_rounded,
              size: 60.r,
              color: Colours.app_main,
            ),
          ),
          SizedBox(height: 20.h),
          Text(
            '发现新版本',
            style: TextStyle(
              fontSize: 40.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 10.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: Colours.app_main.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(
              'v2.0.0',
              style: TextStyle(
                fontSize: 24.sp,
                color: Colours.app_main,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(40.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '更新内容',
            style: TextStyle(
              fontSize: 32.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 24.h),
          Container(
            constraints: BoxConstraints(maxHeight: 300.h),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildUpdateItem('优化用户体验，提升应用性能'),
                  _buildUpdateItem('修复已知问题，增强稳定性'),
                  _buildUpdateItem('新增多项实用功能'),
                  _buildUpdateItem('界面全面升级，视觉更清爽'),
                ],
              ),
            ),
          ),
          SizedBox(height: 40.h),
          _buildButtons(context),
        ],
      ),
    );
  }

  Widget _buildUpdateItem(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 8.h),
            width: 12.r,
            height: 12.r,
            decoration: BoxDecoration(
              color: Colours.app_main,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 28.sp,
                color: Colors.grey[700],
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildButton(
            text: '稍后再说',
            isPrimary: false,
            onTap: () => Navigator.pop(context),
          ),
        ),
        SizedBox(width: 24.w),
        Expanded(
          child: _buildButton(
            text: '立即更新',
            isPrimary: true,
            onTap: () {
              Navigator.pop(context);
              Get.to(
                const WebViewPage(
                  loadResource: "https://www.pgyer.com/ER0YOhzL",
                  webViewType: WebViewType.URL,
                  title: "下载页面",
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildButton({
    required String text,
    required bool isPrimary,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 88.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isPrimary ? Colours.app_main : Colors.grey[100],
          borderRadius: BorderRadius.circular(44.r),
          border: isPrimary
              ? null
              : Border.all(
                  color: Colors.grey[300]!,
                  width: 2,
                ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 30.sp,
            fontWeight: FontWeight.w500,
            color: isPrimary ? Colors.white : Colors.grey[700],
          ),
        ),
      ),
    );
  }
}
