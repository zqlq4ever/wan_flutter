import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'banner_logic.dart';

abstract class BaseBannerController {
  void reload(bool load);
}

class BannerController extends BaseBannerController {
  BannerLogic? logic;

  @override
  void reload(bool load) {
    logic?.getBannerList();
  }

  void initState() {
    //组件初始化阶段获取数据
    logic ??= BannerLogic();
    logic?.getBannerList();
  }

  void dispose() {
    logic?.dispose();
  }
}

typedef BannerClick = Function(String title, String url);

class BannerWidget extends StatefulWidget {
  const BannerWidget({
    super.key,
    this.itemClick,
    required this.controller,
  });

  final BannerClick? itemClick;
  final BannerController? controller;

  @override
  State<StatefulWidget> createState() {
    return _BannerWidgetState();
  }
}

class _BannerWidgetState extends State<BannerWidget> {
  @override
  void initState() {
    super.initState();
    widget.controller?.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        initialData: widget.controller?.logic?.state,
        stream: widget.controller?.logic?.getStream(),
        builder: (context, AsyncSnapshot<BannerState> snapshot) {
          if (snapshot.data?.bannerList == null || snapshot.data?.bannerList?.isEmpty == true) {
            return SizedBox(height: 20.h);
          }

          return Container(
            width: double.infinity,
            height: 150.h,
            margin: EdgeInsets.only(left: 23.w, right: 23.w, top: 20.h),
            child: Swiper(
              autoplay: true,
              duration: 1000,
              viewportFraction: 0.85,
              scale: 0.85,
              pagination: const SwiperPagination(),
              itemCount: snapshot.data?.bannerList?.length ?? 0,
              itemBuilder: (BuildContext context, int index) {
                return ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(5.r)),
                  child: CachedNetworkImage(
                      fit: BoxFit.fill,
                      placeholder: (context, url) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                      imageUrl: snapshot.data?.bannerList?[index].imagePath ?? ""),
                );
              },
              onTap: (int index) {
                var banner = snapshot.data?.bannerList?[index];
                var url = banner?.url ?? "";
                var title = banner?.title ?? "";
                widget.itemClick?.call(title, url);
              },
            ),
          );
        });
  }

  @override
  void dispose() {
    widget.controller?.dispose();
    super.dispose();
  }
}
