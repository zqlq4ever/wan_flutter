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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Obx(() {
          return ListView.builder(
              shrinkWrap: true,
              itemCount: controller.list.length,
              itemBuilder: (context, index) {
                return knowledgeItem(controller.list[index]);
              });
        }),
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
        margin: EdgeInsets.symmetric(horizontal: 30.w, vertical: 16.h),
        padding: EdgeInsets.all(16.r),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item?.name ?? "",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colours.app_main,
                      fontSize: 36.sp, // 放大2倍
                    ),
                  ),
                  SizedBox(height: 24.h), // 放大2倍
                  Wrap(
                    spacing: 24.w, // 放大2倍
                    runSpacing: 16.h, // 放大2倍
                    children: buildChildren(item?.children),
                  ),
                ],
              ),
            ),
            Opacity(
              opacity: 0.7,
              child: Image.asset(
                "assets/images/img_arrow_right.png",
                height: 56.r, // 放大2倍
                width: 56.r, // 放大2倍
              ),
            )
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
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Text(
          value?.name ?? "",
          style: TextStyle(
            fontSize: 28.sp,
            color: Colors.black87,
          ),
        ),
      ));
    }
    return list;
  }
}
