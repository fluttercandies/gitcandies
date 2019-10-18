import 'package:shared_preferences/shared_preferences.dart';

class SpUtils {
  static final String spToken = "token";
  static SharedPreferences sp;

  static Future<void> initInstance() async {
    sp ??= await SharedPreferences.getInstance();
  }

  static Future<void> setToken(String value) async =>
      await sp.setString(spToken, value);
}
