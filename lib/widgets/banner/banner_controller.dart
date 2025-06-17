import 'banner_logic.dart';

typedef OnIndexChangeListener = void Function(String url);

class BannerController {
  late BannerLogic logic;
  OnIndexChangeListener? _listener;

  void setIndexChangeListener(OnIndexChangeListener? listener) {
    _listener = listener;
  }

  void changeIndex(String url) {
    _listener?.call(url);
  }

  void reload(bool load) {
    logic.getBannerList();
  }

  void initState() {
    logic = BannerLogic();
    logic.getBannerList();
  }

  void dispose() {
    _listener = null;
    logic.dispose();
  }
}
