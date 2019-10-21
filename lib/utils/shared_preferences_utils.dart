import 'package:shared_preferences/shared_preferences.dart';

class SpUtils {
  static final String spToken = "token";
  static SharedPreferences sp;

  static Future<void> initInstance() async {
    sp ??= await SharedPreferences.getInstance();
  }

  static bool get hasToken => sp.getString(spToken) != null;
  static String get token => sp.getString(spToken);
  static Future<void> setToken(String value) async =>
      await sp.setString(spToken, value);
  static Future<void> removeToken() async => await sp.remove(spToken);
}
