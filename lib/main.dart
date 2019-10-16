import 'package:flutter/material.dart';
import 'package:gitav/constants/themes.dart';

import 'package:gitav/pages/splash_page.dart';
import 'package:github/server.dart';
import 'package:provider/provider.dart';

final GitHub github = createGitHubClient();

void main() async {
    runApp(Provider<GitHub>.value(
        value: github,
        child: GitApp(),
    ));
}

class GitApp extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
        return MaterialApp(
            title: 'Flutter Demo',
            theme: gitavTheme,
            home: SplashPage(),
        );
    }
}
