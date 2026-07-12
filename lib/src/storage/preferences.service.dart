import 'package:shared_preferences/shared_preferences.dart';

class NaPreferences {
  static SharedPreferences? _prefs;

  /// Initialize SharedPreferences. Must be called before using other methods.
  static Future initAsync() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// Gets the instance of SharedPreferences.
  /// Throws an exception if it has not been initialized.
  static SharedPreferences get _instance {
    if (_prefs == null) {
      throw Exception('NaPreferences has not been initialized. Call initAsync() first.');
    }
    return _prefs!;
  }

  /// Retrieves a string value for the given [key].
  static String? getString(String key) => _instance.getString(key);

  /// Saves a string [value] for the given [key].
  static Future<bool> setString(String key, String value) => _instance.setString(key, value);

  /// Retrieves an integer value for the given [key].
  static int? getInt(String key) => _instance.getInt(key);

  /// Saves an integer [value] for the given [key].
  static Future<bool> setInt(String key, int value) => _instance.setInt(key, value);

  /// Retrieves a double value for the given [key].
  static double? getDouble(String key) => _instance.getDouble(key);

  /// Saves a double [value] for the given [key].
  static Future<bool> setDouble(String key, double value) => _instance.setDouble(key, value);

  /// Retrieves a boolean value for the given [key].
  static bool? getBool(String key) => _instance.getBool(key);

  /// Saves a boolean [value] for the given [key].
  static Future<bool> setBool(String key, bool value) => _instance.setBool(key, value);

  /// Retrieves a list of strings for the given [key].
  static List<String>? getStringList(String key) => _instance.getStringList(key);

  /// Saves a list of strings [value] for the given [key].
  static Future<bool> setStringList(String key, List<String> value) => _instance.setStringList(key, value);

  /// Removes the value associated with the given [key].
  static Future<bool> remove(String key) => _instance.remove(key);

  /// Clears all preferences.
  static Future<bool> clear() => _instance.clear();
}
