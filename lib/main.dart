import 'package:flutter/material.dart';
import 'package:github/server.dart';
import 'package:provider/provider.dart';

import 'package:gitav/constants/constants.dart';
import 'package:gitav/constants/themes.dart';
import 'package:gitav/pages/splash_page.dart';
import 'package:gitav/utils/route_util.dart';

//GitHub github = createGitHubClient();

void main() async {
    runApp(GitApp());
}

class GitApp extends StatelessWidget {
    final GlobalKey<NavigatorState> navigatorKey = GlobalKey();

    @override
    Widget build(BuildContext context) {
        Constants.navigatorKey = navigatorKey;
        return Provider<GitHub>(
            builder: (context) => GitHub(),
            dispose: (context, g) => g.dispose(),
            child: MaterialApp(
                navigatorKey: navigatorKey,
                title: 'Flutter Demo',
                theme: gitavTheme,
                routes: RouteUtil.routes,
                home: SplashPage(),
            ),
        );
    }
}
