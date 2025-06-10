import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:wan_android_flutter/repository/model/knowledge_list_model.dart';
import 'package:wan_android_flutter/res/styles.dart';

import '../../route/RoutePath.dart';
import 'knowledge_view_model.dart';

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
        margin: EdgeInsets.symmetric(horizontal: 15.w, vertical: 8.h),
        padding: EdgeInsets.all(8.r),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black12, width: 0.5.r),
          borderRadius: BorderRadius.all(
            Radius.circular(5.r),
          ),
        ),
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
                      color: Colors.black,
                      fontSize: 15.sp,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Wrap(
                    spacing: 10.0, // 水平间距
                    runSpacing: 4.0, // 垂直间距
                    children: buildChildren(item?.children),
                  ),
                ],
              ),
            ),
            Opacity(
              opacity: 0.5,
              child: Image.asset(
                "assets/images/img_arrow_right.png",
                height: 24.r,
                width: 24.r,
              ),
            )
          ],
        ),
      ),
    );
  }

  List<Widget> buildChildren(List<Children?>? children) {
    if (children == null || children.isEmpty) return [];
    var list = <Chip>[];
    for (var value in children) {
      list.add(Chip(
        label: Text(
          value?.name ?? "",
          style: TextStyles.textWhite14,
        ),
        backgroundColor: controller.getRandomPastelColor(),
      ));
    }
    return list;
  }
}
