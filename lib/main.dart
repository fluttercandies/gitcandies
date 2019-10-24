import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';

import 'package:gitcandies/constants/constants.dart';
import 'package:gitcandies/pages/splash_page.dart';
import 'package:gitcandies/providers/providers.dart';
import 'package:gitcandies/utils/utils.dart';

void main() async {
  await SpUtils.initInstance();
  if (ui.window.physicalSize.isEmpty) {
    ui.window.onMetricsChanged = () {
      if (!ui.window.physicalSize.isEmpty) {
        ui.window.onMetricsChanged = null;
        runApp(GitApp());
      }
    };
  } else {
    runApp(GitApp());
  }
}

class GitApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Color _themeColor;
    return MultiProvider(
      providers: providers,
      child: OKToast(
        child: ScrollConfiguration(
          behavior: NoGlowScrollBehavior(),
          child: Consumer<ThemesProvider>(
            builder: (context, provider, _) {
              String colorKey = provider.themeColor;
              if (themeColorMap[colorKey] != null) {
                _themeColor = themeColorMap[colorKey];
              }
              return MaterialApp(
                navigatorKey: Constants.navigatorKey,
                title: 'Git Candies',
                theme: ThemeData(
                  primarySwatch: ColorUtils.swatchFor(_themeColor),
                ),
                routes: RouteUtils.routes,
                home: SplashPage(),
              );
            },
          ),
        ),
      ),
    );
  }
}
