import 'package:gitcandies/constants/themes.dart';

class API {
  static final String host = "https://api.github.com";
  static final String graphicHost = 'https://ghchart.rshah.org';

  static String graphicUrl(String username) =>
      "$graphicHost"
          "/${gitcandiesTheme.primaryColor.value.toRadixString(16).substring(2)}"
          "/$username"
  ;
}
