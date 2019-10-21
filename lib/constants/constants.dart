import 'package:flutter/material.dart';

class Constants {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
}

class NoGlowScrollBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
