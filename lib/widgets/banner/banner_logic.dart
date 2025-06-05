import 'dart:async';
import 'dart:developer';

import 'package:wan_android_flutter/repository/api/wan_api.dart';
import 'package:wan_android_flutter/repository/model/home_banner_bean.dart';

class BannerLogic {
  //初始化状态数据
  final BannerState state = BannerState();

  //获取流控制器
  final _controller = StreamController<BannerState>.broadcast(onListen: () {
    log("BannerLogic _controller onListen");
  }, onCancel: () {
    log("BannerLogic _controller onCancel");
  });

  //获取流控制器正在控制的流
  Stream<BannerState> getStream() {
    return _controller.stream;
  }

  ///获取Banner列表
  Future getBannerList() async {
    try {
      List<HomeBannerBean>? banner = await WanApi.instance.getBannerList();
      state.bannerList = banner;
    } catch (error) {
      state.bannerList = [];
    }
    _controller.add(state);
  }

  //需要在state-》dispose中调用
  void dispose() {
    _controller.close();
  }
}

class BannerState {
  List<HomeBannerBean>? bannerList = [];
}
