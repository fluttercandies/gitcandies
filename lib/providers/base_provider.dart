import 'package:flutter/material.dart';
import 'package:github/github.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

import 'package:gitcandies/constants/constants.dart';
import 'package:gitcandies/utils/utils.dart';

class BaseProvider extends ChangeNotifier with InputCheckMixin {
  static GitHub _gitHub;

  static HttpUtils _httpUtils = HttpUtils();

  RouteHelper get route => RouteHelper();

  T getProvider<T>() {
    return Provider.of<T>(route.navigatorKey.currentContext);
  }

  Scopes get scopes => Scopes();

  // ignore: unnecessary_getters_setters
  GitHub get github => _gitHub;

  // ignore: unnecessary_getters_setters
  set github(GitHub value) => _gitHub = value;

  HttpUtils get httpUtils => _httpUtils;
}

mixin InputCheckMixin {
  bool checkInputEmpty(String input, [String tip]) {
    if (input == null || input.trim().isEmpty) {
      if (tip != null) {
        showToast(tip);
      }
      return false;
    }
    return true;
  }

  String makeEmptyTip(String name) {
    return "The $name mustn't be null.";
  }
}
