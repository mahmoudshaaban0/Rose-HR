import 'package:shared_preferences/shared_preferences.dart';

class AppManager {
  factory AppManager() => _internalInstance ??= AppManager._();
  AppManager._();

  static AppManager? _internalInstance;
  SharedPreferences? _prefs;

  static Future<void> initialize(SharedPreferences prefs) async {
    AppManager()._prefs = prefs;
  }

  SharedPreferences get _preferences {
    if (_prefs == null) {
      throw Exception('AppManager not initialized. Call AppManager.init() first.');
    }
    return _prefs!;
  }

  Future<bool> setString(String key, String value) async {
    return _preferences.setString(key, value);
  }

  String? getString(String key) {
    return _preferences.getString(key);
  }

  Future<bool> setInt(String key, int value) async {
    return _preferences.setInt(key, value);
  }

  int? getInt(String key) {
    return _preferences.getInt(key);
  }

  Future<bool> setBool(String key, {required bool value}) async {
    return _preferences.setBool(key, value);
  }

  bool? getBool({required String key}) {
    return _preferences.getBool(key);
  }

  Future<bool> setDouble(String key, double value) async {
    return _preferences.setDouble(key, value);
  }

  double? getDouble(String key) {
    return _preferences.getDouble(key);
  }

  Future<bool> setStringList(String key, List<String> value) async {
    return _preferences.setStringList(key, value);
  }

  List<String>? getStringList(String key) {
    return _preferences.getStringList(key);
  }

  bool containsKey(String key) {
    return _preferences.containsKey(key);
  }

  Future<bool> remove(String key) async {
    return _preferences.remove(key);
  }

  Future<bool> clear() async {
    return _preferences.clear();
  }

  Set<String> getAllKeys() {
    return _preferences.getKeys();
  }

  Future<void> reload() async {
    await _preferences.reload();
  }
}
