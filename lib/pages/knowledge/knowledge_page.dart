import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wan_android_flutter/repository/model/knowledge_list_model.dart';
import 'package:wan_android_flutter/res/colors.dart';

import '../../route/route_path_constant.dart';
import 'knowledge_viewmodel.dart';

/// 知识体系页面
class KnowledgePage extends GetView<KnowledgeViewModel> {
  const KnowledgePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colours.bg_color,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            SizedBox(height: 20.h),
            Expanded(
              child: Obx(() {
                return ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
                    shrinkWrap: true,
                    itemCount: controller.list.length,
                    itemBuilder: (context, index) {
                      return knowledgeItem(controller.list[index]);
                    });
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 32.h),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 8.w,
            height: 40.h,
            decoration: BoxDecoration(
              color: Colours.app_main,
              borderRadius: BorderRadius.circular(4.r),
            ),
          ),
          SizedBox(width: 20.w),
          Text(
            "知识体系",
            style: TextStyle(
              fontSize: 54.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget knowledgeItem(KnowledgeModel? item) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(
          RoutePath.knowledgeDetails,
          arguments: controller.generalParams(item?.children),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 20.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 15,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(28.w, 28.w, 28.w, 0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      item?.name ?? "",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colours.app_main,
                        fontSize: 44.sp,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(12.r),
                    decoration: BoxDecoration(
                      color: Colours.app_main.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Icon(
                      Icons.arrow_forward_ios,
                      size: 28.r,
                      color: Colours.app_main,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),
            Padding(
              padding: EdgeInsets.fromLTRB(28.w, 0, 28.w, 28.w),
              child: Wrap(
                spacing: 16.w,
                runSpacing: 16.h,
                children: buildChildren(item?.children),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> buildChildren(List<Children?>? children) {
    if (children == null || children.isEmpty) return [];
    var list = <Widget>[];
    for (var value in children) {
      list.add(Container(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: Colors.grey[200]!, width: 1),
        ),
        child: Text(
          value?.name ?? "",
          style: TextStyle(
            fontSize: 34.sp,
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
      ));
    }
    return list;
  }
}
