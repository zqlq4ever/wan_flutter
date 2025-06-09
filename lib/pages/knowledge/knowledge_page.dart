import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';
import 'package:wan_android_flutter/pages/knowledge/details/knowledge_details_tab_page.dart';
import 'package:wan_android_flutter/repository/model/knowledge_list_model.dart';

import '../../route/RoutePath.dart';
import 'knowledge_view_model.dart';

///知识体系页面
class KnowledgePage extends StatefulWidget {
  const KnowledgePage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _KnowledgePageState();
  }
}

class _KnowledgePageState extends State<KnowledgePage> {
  var model = KnowledgeViewModel();

  @override
  void initState() {
    super.initState();
    model.getKnowledgeList();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        return model;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: knowledgeListview(),
        ),
      ),
    );
  }

  Widget knowledgeListview() {
    return Consumer<KnowledgeViewModel>(builder: (context, value, child) {
      return ListView.builder(
          shrinkWrap: true,
          itemCount: value.list?.length ?? 0,
          itemBuilder: (context, index) {
            return knowledgeItem(value.list?[index]);
          });
    });
  }

  Widget knowledgeItem(KnowledgeModel? item) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(
          RoutePath.knowledgeDetails,
          arguments: model.generalParams(item?.children),
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
                  Text(model.generalChildNames(item?.children)),
                ],
              ),
            ),
            Image.asset("assets/images/img_arrow_right.png", height: 24.r, width: 24.r)
          ],
        ),
      ),
    );
  }
}
