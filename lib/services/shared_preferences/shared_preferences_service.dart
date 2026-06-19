import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  SharedPreferences? _preferences;

  Future<SharedPreferences> get _instance async {
    return _preferences ??= await SharedPreferences.getInstance();
  }

  Future<bool> put<T extends Object>(String key, T value) async {
    final preferences = await _instance;

    if (value is String) return preferences.setString(key, value);
    if (value is int) return preferences.setInt(key, value);
    if (value is double) return preferences.setDouble(key, value);
    if (value is bool) return preferences.setBool(key, value);
    if (value is List<String>) return preferences.setStringList(key, value);

    throw UnsupportedError(
      'SharedPreferencesService only supports String, int, double, bool, '
      'and List<String> values.',
    );
  }

  Future<Object?> get(String key) async {
    final preferences = await _instance;
    return preferences.get(key);
  }

  Future<String?> getString(String key) async {
    final preferences = await _instance;
    return preferences.getString(key);
  }

  Future<int?> getInt(String key) async {
    final preferences = await _instance;
    return preferences.getInt(key);
  }

  Future<double?> getDouble(String key) async {
    final preferences = await _instance;
    return preferences.getDouble(key);
  }

  Future<bool?> getBool(String key) async {
    final preferences = await _instance;
    return preferences.getBool(key);
  }

  Future<List<String>?> getStringList(String key) async {
    final preferences = await _instance;
    return preferences.getStringList(key);
  }

  Future<bool> containsKey(String key) async {
    final preferences = await _instance;
    return preferences.containsKey(key);
  }

  Future<bool> remove(String key) async {
    final preferences = await _instance;
    return preferences.remove(key);
  }

  Future<bool> clear() async {
    final preferences = await _instance;
    return preferences.clear();
  }
}
