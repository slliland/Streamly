import 'package:shared_preferences/shared_preferences.dart';

/// Cache Management Class
/// This class provides an abstraction layer for managing cached data using `SharedPreferences`.
class HiCache {
  /// Instance of SharedPreferences
  SharedPreferences? prefs;

  /// Private constructor to prevent external instantiation
  HiCache._() {
    init();
  }

  /// Singleton instance of HiCache
  static HiCache? _instance;

  /// Private constructor with pre-initialized SharedPreferences
  HiCache._pre(SharedPreferences prefs) {
    this.prefs = prefs;
  }

  /// Pre-initialize the cache to ensure `prefs` is ready before use.
  /// This method should be called before accessing the cache.
  static Future<HiCache> preInit() async {
    if (_instance == null) {
      var prefs = await SharedPreferences.getInstance();
      _instance = HiCache._pre(prefs);
    }
    return _instance!;
  }

  /// Returns the singleton instance of HiCache.
  /// If not already initialized, it creates a new instance.
  static HiCache getInstance() {
    if (_instance == null) {
      _instance = HiCache._();
    }
    return _instance!;
  }

  /// Initializes the `SharedPreferences` instance if it is not already initialized.
  void init() async {
    if (prefs == null) {
      prefs = await SharedPreferences.getInstance();
    }
  }

  /// Saves a string value to the cache.
  /// [key]: The key under which the value will be stored.
  /// [value]: The string value to be saved.
  setString(String key, String value) {
    prefs?.setString(key, value);
  }

  /// Saves a double value to the cache.
  /// [key]: The key under which the value will be stored.
  /// [value]: The double value to be saved.
  setDouble(String key, double value) {
    prefs?.setDouble(key, value);
  }

  /// Saves an integer value to the cache.
  /// [key]: The key under which the value will be stored.
  /// [value]: The integer value to be saved.
  setInt(String key, int value) {
    prefs?.setInt(key, value);
  }

  /// Saves a boolean value to the cache.
  /// [key]: The key under which the value will be stored.
  /// [value]: The boolean value to be saved.
  setBool(String key, bool value) {
    prefs?.setBool(key, value);
  }

  /// Saves a list of strings to the cache.
  /// [key]: The key under which the value will be stored.
  /// [value]: The list of strings to be saved.
  setStringList(String key, List<String> value) {
    prefs?.setStringList(key, value);
  }

  /// Removes a value from the cache.
  /// [key]: The key whose associated value will be removed.
  remove(String key) {
    prefs?.remove(key);
  }

  /// Retrieves a value from the cache by its key.
  /// [key]: The key associated with the value to retrieve.
  /// Returns the value if found, or `null` if not present.
  T? get<T>(String key) {
    var result = prefs?.get(key);
    if (result != null) {
      return result as T;
    }
    return null;
  }
}
