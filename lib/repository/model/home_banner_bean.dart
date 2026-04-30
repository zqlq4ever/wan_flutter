/// desc : "我们支持订阅啦~"
/// id : 30
/// imagePath : "https://wanandroid.com/blogimgs/42da12d8-de56-4439-b40c-eab66c227a4b.png"
/// isVisible : 1
/// order : 2
/// title : "我们支持订阅啦~"
/// type : 0
/// url : "https://wanandroid.com/blog/show/3352"

class HomeBannerListModel {
  List<HomeBannerBean> list = [];

  HomeBannerListModel.fromJson(dynamic json) {
    if (json is List) {
      for (var element in json) {
        list.add(HomeBannerBean.fromJson(element));
      }
    }
  }
}

class HomeBannerBean {
  HomeBannerBean({
    String? desc,
    num? id,
    String? imagePath,
    num? isVisible,
    num? order,
    String? title,
    num? type,
    String? url,
  }) {
    _desc = desc;
    _id = id;
    _imagePath = imagePath;
    _isVisible = isVisible;
    _order = order;
    _title = title;
    _type = type;
    _url = url;
  }

  HomeBannerBean.fromJson(dynamic json) {
    _desc = json['desc'];
    _id = json['id'];
    _imagePath = json['imagePath'];
    _isVisible = json['isVisible'];
    _order = json['order'];
    _title = json['title'];
    _type = json['type'];
    _url = json['url'];
  }

  String? _desc;
  num? _id;
  String? _imagePath;
  num? _isVisible;
  num? _order;
  String? _title;
  num? _type;
  String? _url;

  String? get desc => _desc;

  num? get id => _id;

  String? get imagePath => _imagePath;

  num? get isVisible => _isVisible;

  num? get order => _order;

  String? get title => _title;

  num? get type => _type;

  String? get url => _url;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['desc'] = _desc;
    map['id'] = _id;
    map['imagePath'] = _imagePath;
    map['isVisible'] = _isVisible;
    map['order'] = _order;
    map['title'] = _title;
    map['type'] = _type;
    map['url'] = _url;
    return map;
  }
}
