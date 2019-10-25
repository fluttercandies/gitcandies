import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:gitcandies/constants/constants.dart';
import 'package:gitcandies/pages/splash_page.dart';
import 'package:gitcandies/providers/providers.dart';
import 'package:gitcandies/utils/utils.dart';

import 'package:gitcandies/gitcandies_route.dart';
import 'package:gitcandies/gitcandies_route_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
    return OKToast(
      child: ScrollConfiguration(
          behavior: NoGlowScrollBehavior(),
          child: MultiProvider(
            providers: providers,
            child: Consumer<ThemesProvider>(
              builder: (context, provider, _) {
                String colorKey = provider.themeColor;
                Color _themeColor;
                if (themeColorMap[colorKey] != null) {
                  _themeColor = themeColorMap[colorKey];
                }
                return MaterialApp(
                  navigatorKey: Constants.navigatorKey,
                  title: 'Git Candies',
                  navigatorObservers: [
                    FFNavigatorObserver(
                        showStatusBarChange: (bool showStatusBar) {
                      if (showStatusBar) {
                        SystemChrome.setEnabledSystemUIOverlays(
                            SystemUiOverlay.values);
//                        /// Set according to theme brightness.
//                        SystemChrome.setSystemUIOverlayStyle(
//                            SystemUiOverlayStyle.dark);
                      } else {
                        SystemChrome.setEnabledSystemUIOverlays([]);
                      }
                    })
                  ],
                  builder: (c, w) {
                    ScreenUtil.instance = ScreenUtil(
                        width: 750, height: 1334, allowFontScaling: true)
                      ..init(c);
                    return NoScaleTextWidget(child: w);
                  },
                  theme: ThemeData(
                    primarySwatch: ColorUtils.swatchFor(_themeColor),
                  ),
                  onGenerateRoute: (RouteSettings settings) {
                    var routeResult = getRouteResult(
                      name: settings.name,
                      arguments: settings.arguments,
                    );
                    if (routeResult.showStatusBar != null ||
                        routeResult.routeName != null) {
                      settings = FFRouteSettings(
                          name: settings.name,
                          isInitialRoute: settings.isInitialRoute,
                          routeName: routeResult.routeName,
                          arguments: settings.arguments,
                          showStatusBar: routeResult.showStatusBar);
                    }
                    Widget page = routeResult.widget ?? SplashPage();

                    if (settings.arguments != null &&
                        settings.arguments is Map<String, dynamic>) {
                      return ((settings.arguments
                              as Map<String, dynamic>)['routeBuilder']
                          as RouteBuilder)(page);
                    }

                    switch (routeResult.pageRouteType) {
                      case PageRouteType.material:
                        return MaterialPageRoute(
                            settings: settings, builder: (c) => page);
                      case PageRouteType.cupertino:
                        return CupertinoPageRoute(
                            settings: settings, builder: (c) => page);
                      case PageRouteType.transparent:
                        return FFTransparentPageRoute(
                            settings: settings,
                            pageBuilder: (BuildContext context,
                                    Animation<double> animation,
                                    Animation<double> secondaryAnimation) =>
                                page);
                      default:
                        return Platform.isIOS
                            ? CupertinoPageRoute(
                                settings: settings, builder: (c) => page)
                            : MaterialPageRoute(
                                settings: settings, builder: (c) => page);
                    }
                  },
                  home: SplashPage(),
                );
              },
            ),
          )),
    );
  }
}
