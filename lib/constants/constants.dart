import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class Constants {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static String timeHandler(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);
    if (difference >= Duration(days: 365)) {
      return "on ${DateFormat("LLL dd yyyy").format(time)}";
    } else if (difference >= Duration(days: 30)) {
      return "on ${DateFormat("LLL d").format(time)}";
    } else if (difference >= Duration(days: 2)) {
      return "${difference.inDays} days ago";
    } else if (difference >= Duration(days: 24)) {
      return "on yesterday";
    } else if (difference >= Duration(hours: 1)) {
      return "${difference.inHours} hours ago";
    } else if (difference >= Duration(minutes: 1)) {
      return "${difference.inMinutes} minutes ago";
    } else if (difference >= Duration(seconds: 1)) {
      return "${difference.inSeconds} seconds ago";
    }
    return time.toString();
  }

}

class NoGlowScrollBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
