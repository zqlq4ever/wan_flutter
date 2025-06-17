import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'banner_controller.dart';
import 'banner_logic.dart';

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
        initialData: widget.controller?.logic.state,
        stream: widget.controller?.logic.getStream(),
        builder: (context, AsyncSnapshot<BannerState> snapshot) {
          if (snapshot.data?.bannerList == null || snapshot.data?.bannerList?.isEmpty == true) {
            return SizedBox(height: 20.h);
          }

          return Container(
            width: double.infinity,
            height: 180.h,
            margin: const EdgeInsets.all(20.0),
            child: Swiper(
              autoplay: true,
              duration: 1000,
              scale: 0.8,
              pagination: const SwiperPagination(),
              itemCount: snapshot.data?.bannerList?.length ?? 0,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  margin: EdgeInsets.only(bottom: 16.h),
                  color: Colors.white,
                  elevation: 1,
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(5.r)),
                    child: CachedNetworkImage(
                      fit: BoxFit.fill,
                      imageUrl: snapshot.data?.bannerList?[index].imagePath ?? "",
                    ),
                  ),
                );
              },
              onTap: (int index) {
                var banner = snapshot.data?.bannerList?[index];
                var url = banner?.url ?? "";
                var title = banner?.title ?? "";
                widget.itemClick?.call(title, url);
              },
              onIndexChanged: (index) {
                widget.controller?.changeIndex(
                  widget.controller?.logic.state.bannerList?[index].imagePath ?? "https://picsum.photos/400/200",
                );
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
