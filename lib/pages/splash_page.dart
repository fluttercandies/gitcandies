import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:gitcandies/constants/constants.dart';
import 'package:gitcandies/providers/providers.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      Provider.of<LoginProvider>(context).checkLogin();
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
