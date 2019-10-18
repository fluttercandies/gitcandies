import 'package:flutter/material.dart';
import 'package:gitav/utils/route_util.dart';
import 'package:github/server.dart';
import 'package:provider/provider.dart';

class BaseProvider extends ChangeNotifier {
  static GitHub _gitHub;

  RouteHelper get route => RouteHelper();

  T getProvider<T>() {
    return Provider.of<T>(route.navigatorKey.currentContext);
  }

  // ignore: unnecessary_getters_setters
  GitHub get github => _gitHub;

  // ignore: unnecessary_getters_setters
  set github(GitHub value) => _gitHub = value;
}
