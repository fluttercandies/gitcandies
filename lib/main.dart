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
      child: MultiProvider(
        providers: providers,
        child: Consumer<ThemesProvider>(
          builder: (context, provider, _) {
            final colorKey = provider.themeColor;
            Color _themeColor;
            if (themeColorMap[colorKey] != null) {
              _themeColor = themeColorMap[colorKey];
            }
            return MaterialApp(
              navigatorKey: Constants.navigatorKey,
              title: 'GitCandies',
              navigatorObservers: [
                FFNavigatorObserver(showStatusBarChange: (bool showStatusBar) {
                  if (showStatusBar) {
                    SystemChrome.setEnabledSystemUIOverlays(
                      SystemUiOverlay.values,
                    );
                  } else {
                    SystemChrome.setEnabledSystemUIOverlays([]);
                  }
                })
              ],
              builder: (c, w) {
                ScreenUtil.instance = ScreenUtil.getInstance()
                  ..allowFontScaling = true
                  ..init(c);
                return NoScaleTextWidget(child: w);
              },
              theme: ThemeData(
                primarySwatch: ColorUtils.swatchFor(_themeColor),
              ),
              onGenerateRoute: (RouteSettings settings) {
                RouteResult routeResult = getRouteResult(
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
                    showStatusBar: routeResult.showStatusBar,
                  );
                }
                Widget page = routeResult.widget ?? SplashPage();

                if (settings.arguments != null &&
                    settings.arguments is Map<String, dynamic>) {
                  RouteBuilder builder = (settings.arguments
                      as Map<String, dynamic>)['routeBuilder'];
                  if (builder != null) return builder(page);
                }

                switch (routeResult.pageRouteType) {
                  case PageRouteType.material:
                    return MaterialPageRoute(
                      settings: settings,
                      builder: (c) => page,
                    );
                  case PageRouteType.cupertino:
                    return CupertinoPageRoute(
                      settings: settings,
                      builder: (c) => page,
                    );
                  case PageRouteType.transparent:
                    return FFTransparentPageRoute(
                        settings: settings,
                        pageBuilder: (
                          BuildContext context,
                          Animation<double> animation,
                          Animation<double> secondaryAnimation,
                        ) =>
                            page);
                  default:
                    return Platform.isIOS
                        ? CupertinoPageRoute(
                            settings: settings, builder: (c) => page)
                        : MaterialPageRoute(
                            settings: settings,
                            builder: (c) => page,
                          );
                }
              },
              home: SplashPage(),
            );
          },
        ),
      ),
    );
  }
}
