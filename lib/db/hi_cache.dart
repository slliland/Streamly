import 'package:shared_preferences/shared_preferences.dart';

/// Cache Management Class
class HiCache {
  SharedPreferences? prefs;

  HiCache._() {
    init();
  }

  HiCache._pre(this.prefs);

  Future<void> init() async {
    prefs ??= await SharedPreferences.getInstance();
  }

  static HiCache? _instance;

  /// Pre-initialize to prevent `prefs` from being null when `get` is called.
  static Future<HiCache> preInit() async {
    if (_instance == null) {
      var prefs = await SharedPreferences.getInstance();
      _instance = HiCache._pre(prefs);
    }
    return _instance!;
  }

  static HiCache getInstance() {
    _instance ??= HiCache._();
    return _instance!;
  }

  //Save data into Cache
  void setString(String key, String value) {
    prefs?.setString(key, value);
  }

  void setBool(String key, bool value) {
    prefs?.setBool(key, value);
  }

  void setInt(String key, int value) {
    prefs?.setInt(key, value);
  }

  void setStringList(String key, List<String> value) {
    prefs?.setStringList(key, value);
  }

  // Return (Get Method)
  T? get<T>(String key) {
    return prefs?.get(key) as T?;
  }
}
