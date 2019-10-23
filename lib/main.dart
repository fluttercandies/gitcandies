import 'package:flutter/material.dart';
import 'package:gitcandies/providers/themes_provider.dart';
import 'package:gitcandies/utils/color_utils.dart';
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
    Color _themeColor;
    return MultiProvider(
      providers: providers,
      child: Consumer<ThemesProvider>(
        builder: (context, provider, _) {
          String colorKey = provider.themeColor;
          if (themeColorMap[colorKey] != null) {
            _themeColor = themeColorMap[colorKey];
          }
          return OKToast(
            child: ScrollConfiguration(
              behavior: NoGlowScrollBehavior(),
              child: MaterialApp(
                navigatorKey: Constants.navigatorKey,
                title: 'Git Candies',
                theme: ThemeData(
                  primarySwatch: ColorUtils.swatchFor(_themeColor),
                ),
                routes: RouteUtils.routes,
                home: SplashPage(),
              ),
            ),
          );
        },
      ),
    );
  }
}
