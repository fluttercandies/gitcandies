import 'package:flutter/material.dart';

import 'package:gitcandies/utils/utils.dart';

class ThemesProvider with ChangeNotifier {
  String _themeColor = SpUtils.theme ?? 'GitHub';

  String get themeColor => _themeColor;

  setTheme(String themeColor) {
    _themeColor = themeColor;
    notifyListeners();
  }
}
