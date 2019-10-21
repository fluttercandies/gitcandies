import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:gitcandies/constants/resource.dart';
import 'package:gitcandies/pages/login_page.dart';
import 'package:gitcandies/providers/login_provider.dart';
import 'package:gitcandies/utils/route_util.dart';
import 'package:gitcandies/utils/shared_preferences_utils.dart';


class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>{
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
        RouteHelper().pushWidget(
          LoginPage(pushFromSplash: true),
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
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Image.asset(R.ASSETS_GITHUB_OCTOCAT_OCTOCAT_PNG),
        Image.asset(R.ASSETS_GITHUB_LOGOS_LOGO_WHITE_PNG),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: cover,
      ),
    );
  }
}
