
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:gitav/constants/assets.dart';
import 'package:gitav/constants/constants.dart';
import 'package:gitav/pages/login_page.dart';



class SplashPage extends StatefulWidget {
    @override
    _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>{
    @override
    void initState() {
        SchedulerBinding.instance.addPostFrameCallback((_) {
            Future.delayed(const Duration(seconds: 2), () {
                Constants.navigatorKey.currentState.push(PageRouteBuilder(
                    transitionDuration: Duration(milliseconds: 1000),
                    pageBuilder: (_, __, ___) {
                        return FadeTransition(
                            opacity: __,
                            child: LoginPage(),
                        );
                    },
                ));
            });
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
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
                Image.asset(R.octocat),
                Image.asset(R.logoWhite),
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
