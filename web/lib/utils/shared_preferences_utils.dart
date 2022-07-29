import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesUtils {
  static Future setBool(key, value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value);
  }

  static Future getBool(key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key);
  }
}
