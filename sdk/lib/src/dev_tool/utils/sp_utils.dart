import 'package:shared_preferences/shared_preferences.dart';

class SPUtils {
  static final String _PREFIX = "fair_dev_tool_key_";
  static final String _KEY_LOCAL_HOST = _PREFIX + "local_host";
  static final String _KEY_BUNDLE_ID = _PREFIX + "bundle_id";
  static final String _KEY_SELECT_MODE = _PREFIX + "select_mode";
  static final String _KEY_SELECT_ENV = _PREFIX + "select_env";

  static final Future<SharedPreferences> _prefs =
      SharedPreferences.getInstance();

  static Future<bool> recordLocalHost(String localHost) async {
    final SharedPreferences prefs = await _prefs;
    return prefs.setString(_KEY_LOCAL_HOST, localHost);
  }

  static Future<String?> getLocalHost() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString(_KEY_LOCAL_HOST);
  }

  static Future<bool> recordBundleIdByEnv(String bundleId, String env) async {
    final SharedPreferences prefs = await _prefs;
    return prefs.setString(_KEY_BUNDLE_ID + env, bundleId);
  }

  static Future<String?> getBundleIdByEnv(String env) async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString(_KEY_BUNDLE_ID + env);
  }

  static Future<bool> recordLastSelectMode(String mode) async {
    final SharedPreferences prefs = await _prefs;
    return prefs.setString(_KEY_SELECT_MODE, mode);
  }

  static Future<String?> getLastSelectMode() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString(_KEY_SELECT_MODE);
  }

  static Future<bool> recordLastSelectEnv(String envName) async {
    final SharedPreferences prefs = await _prefs;
    return prefs.setString(_KEY_SELECT_ENV, envName);
  }

  static Future<String?> getLastSelectEnv() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString(_KEY_SELECT_ENV);
  }
}
