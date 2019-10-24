import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:gitcandies/constants/constants.dart';
import 'package:gitcandies/pages/login_page.dart';
import 'package:gitcandies/providers/providers.dart';
import 'package:gitcandies/utils/utils.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      navigate();
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void navigate() {
    Future.delayed(const Duration(seconds: 2), () {
      if (SpUtils.hasToken) {
        Provider.of<LoginProvider>(context).loginWithToken(SpUtils.token);
      } else {
        RouteHelper().pushRoute(
          PageRouteBuilder(
            transitionDuration: Duration.zero,
            pageBuilder: (
                BuildContext context,
                Animation animation,
                Animation secondaryAnimation
                ) => FadeTransition(
              opacity: animation,
              child: LoginPage(),
            ),
          ),
          replaceRoot: true,
        );
      }
    });
  }

  Widget get cover => Container(
        padding: const EdgeInsets.all(80.0),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
        ),
        child: Center(
          child: Image.asset(
            R.ASSETS_LOGO_FRONT_PNG,
            width: Screen.width / 2,
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return cover;
  }
}
