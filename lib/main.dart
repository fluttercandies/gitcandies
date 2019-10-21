import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

import 'package:gitcandies/constants/constants.dart';
import 'package:gitcandies/constants/themes.dart';
import 'package:gitcandies/pages/splash_page.dart';
import 'package:gitcandies/providers/providers.dart';
import 'package:gitcandies/utils/route_util.dart';
import 'package:gitcandies/utils/shared_preferences_utils.dart';


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
        child: ScrollConfiguration(
          behavior: NoGlowScrollBehavior(),
          child: MaterialApp(
            navigatorKey: Constants.navigatorKey,
            title: 'Flutter Demo',
            theme: gitcandiesTheme,
            routes: RouteUtils.routes,
            home: SplashPage(),
          ),
        ),
      ),
    );
  }
}
