import 'package:flutter/material.dart';

class ThemesProvider with ChangeNotifier {
  String _themeColor = 'GitHub';

  String get themeColor => _themeColor;

  setTheme(String themeColor) {
    _themeColor = themeColor;
    notifyListeners();
  }
}