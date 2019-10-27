import 'package:gitcandies/constants/constants.dart';
import 'package:gitcandies/providers/providers.dart';

class API {
  static final String host = "https://api.github.com";
  static final String graphicHost = 'https://ghchart.rshah.org';

  static String graphicUrl(String username) {
    final currentColor = themeColorMap[ThemesProvider().themeColor];
    return "$graphicHost"
        "/${currentColor.value.toRadixString(16).substring(2)}"
        "/$username";
  }
}
