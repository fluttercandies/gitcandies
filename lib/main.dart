import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

import 'package:gitav/constants/constants.dart';
import 'package:gitav/constants/themes.dart';
import 'package:gitav/pages/splash_page.dart';
import 'package:gitav/providers/providers.dart';
import 'package:gitav/utils/route_util.dart';
import 'package:gitav/utils/shared_preferences_utils.dart';


void main() async {
  await SpUtils.initInstance();
  runApp(GitApp());
}

class GitApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return OKToast(
      child: MultiProvider(
        providers: providers,
        child: MaterialApp(
          navigatorKey: Constants.navigatorKey,
          title: 'Flutter Demo',
          theme: gitavTheme,
          routes: RouteUtils.routes,
          home: SplashPage(),
        ),
      ),
    );
  }
}
