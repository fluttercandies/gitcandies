import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:gitav/constants/assets.dart';

import 'package:gitav/constants/screens.dart';
import 'package:gitav/widgets/waver.dart';


class SplashPage extends StatefulWidget {
    @override
    _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>{
    bool covered = true;

    @override
    void initState() {
        SchedulerBinding.instance.addPostFrameCallback((_) {
            Future.delayed(const Duration(seconds: 3), () {
                if (mounted) setState(() {
                    covered = false;
                });
            });
        });
        super.initState();
    }

    @override
    void dispose() {
        super.dispose();
    }

    Widget get cover => AnimatedPositioned(
        duration: const Duration(seconds: 1),
        top: covered ? 0.0 : -Screen.height,
        curve: Curves.easeIn,
        width: Screen.width,
        height: Screen.height,
        child: Container(
            padding: const EdgeInsets.all(80.0),
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
            ),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                    Image.asset("assets/github/octocat/octocat.png"),
                    Image.asset("assets/github/logos/logo_white.png"),
                ],
            ),
        ),
    );

    Widget get waver => Positioned(
        top: 0.0,
        left: 0.0,
        right: 0.0,
        child: Stack(
            children: <Widget>[
                Waver(
                    opacity: 0.7,
                    size: Size(Screen.width, 200),
                    xOffset: 0,
                    color: Theme.of(context).primaryColor,
                ),
                Waver(
                    opacity: 0.7,
                    size: Size(Screen.width, 200),
                    xOffset: Screen.width ~/ 3 * 1,
                    yOffset: 10,
                    color: Theme.of(context).primaryColor,
                    duration: const Duration(seconds: 5),
                ),
                Waver(
                    opacity: 0.7,
                    size: Size(Screen.width, 200),
                    xOffset: Screen.width ~/ 3 * 2,
                    yOffset: 20,
                    color: Theme.of(context).primaryColor,
                    duration: const Duration(seconds: 8),
                ),
            ],
        ),
    );

    Widget get header => Positioned(
        top: 0.0,
        left: 0.0,
        right: 0.0,
        height: 200.0,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
                Image.asset(R.octocat, height: 50.0),
                Image.asset(R.logoWhite, height: 50.0),
            ],
        ),
    );

    @override
    Widget build(BuildContext context) {
        return AnnotatedRegion(
            value: SystemUiOverlayStyle.light,
            child: Scaffold(
                body: Stack(
                    children: <Widget>[
                        waver,
                        header,
                        cover,
                    ],
                ),
            ),
        );
    }
}
