import 'package:shared_preferences/shared_preferences.dart';

/// 本地持久化存储工具类
class SpUtil {
  SpUtil._();

  static SharedPreferences? _sp;
  static Future<SharedPreferences>? _initFuture;

  /// 启动期初始化（建议在 `main()` 中 await 一次）
  static Future<SharedPreferences> init() {
    final existed = _sp;
    if (existed != null) return Future.value(existed);
    return _initFuture ??= SharedPreferences.getInstance().then((value) {
      _sp = value;
      return value;
    });
  }

  static Future<SharedPreferences> _getSp() async {
    final existed = _sp;
    if (existed != null) return existed;
    return init();
  }

  static Future<bool> saveStringList(String key, List<String> values) async {
    final sp = await _getSp();
    return sp.setStringList(key, values);
  }

  static Future<List<String>?> getStringList(String key) async {
    final sp = await _getSp();
    return sp.getStringList(key);
  }

  static Future<bool> saveBool(String key, bool value) async {
    final sp = await _getSp();
    return sp.setBool(key, value);
  }

  static Future<bool?> getBool(String key) async {
    final sp = await _getSp();
    return sp.getBool(key);
  }

  static Future<bool> saveInt(String key, int value) async {
    final sp = await _getSp();
    return sp.setInt(key, value);
  }

  static Future<int?> getInt(String key) async {
    final sp = await _getSp();
    return sp.getInt(key);
  }

  static Future<bool> saveString(String key, String value) async {
    final sp = await _getSp();
    return sp.setString(key, value);
  }

  static Future<bool> saveDouble(String key, double value) async {
    final sp = await _getSp();
    return sp.setDouble(key, value);
  }

  static Future<bool> saveList(String key, List<String> value) async {
    final sp = await _getSp();
    return sp.setStringList(key, value);
  }

  static Future<Object?> getDynamic(String key) async {
    final sp = await _getSp();
    return sp.get(key);
  }

  static Future<String?> getString(String key) async {
    final sp = await _getSp();
    return sp.getString(key);
  }

  static Future<double?> getDouble(String key) async {
    final sp = await _getSp();
    return sp.getDouble(key);
  }

  static Future<List<String>?> getList(String key) async {
    final sp = await _getSp();
    return sp.getStringList(key);
  }

  static Future<bool> remove(String key) async {
    final sp = await _getSp();
    return sp.remove(key);
  }

  static Future<bool> removeAll(String key) async {
    final sp = await _getSp();
    return sp.clear();
  }
}
