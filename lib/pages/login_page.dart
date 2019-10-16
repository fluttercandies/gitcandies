import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

import 'package:gitav/constants/assets.dart';
import 'package:gitav/constants/screens.dart';
import 'package:gitav/widgets/waver.dart';


class LoginPage extends StatefulWidget {
    @override
    _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>{
    bool covered = true;
    bool obscured = true;
    String _username, _password;

    TextStyle get fieldStyle => Theme.of(context).textTheme.body1.copyWith(
        fontSize: 20.0,
        textBaseline: TextBaseline.alphabetic,
    );

    StrutStyle get fieldStrutStyle => StrutStyle(
        fontSize: 20.0,
        height: 1.5,
        forceStrutHeight: true,
    );

    @override
    void initState() {
        SchedulerBinding.instance.addPostFrameCallback((_) {
            setState(() {
                covered = false;
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
                    Image.asset(R.octocat),
                    Image.asset(R.logoWhite),
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
        height: 180.0,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
                Image.asset(R.octocat, height: 50.0),
                Image.asset(R.logoWhite, height: 50.0),
            ],
        ),
    );

    Widget get usernameField => Container(
        child: TextField(
            decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 6.0,
                    vertical: 10.0,
                ),
                labelText: "GitHub username",
                labelStyle: Theme.of(context).textTheme.body1.copyWith(
                    color: Colors.grey[500],
                    fontSize: 16.0,
                ),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.grey[350],
                    ),
                ),
            ),
            style: fieldStyle,
            strutStyle: fieldStrutStyle,
            onChanged: (String username) {
                _username = username;
            },
        ),
    );

    Widget get passwordField => Container(
        child: TextField(
            decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 6.0,
                    vertical: 10.0,
                ),
                labelText: "Password",
                labelStyle: Theme.of(context).textTheme.body1.copyWith(
                    color: Colors.grey[500],
                    fontSize: 16.0,
                ),
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.grey[350],
                    ),
                ),
                suffixIcon: IconButton(
                    icon: Icon(
                        obscured ? Icons.visibility : Icons.visibility_off,
                        color: obscured ? Colors.grey[500] : Colors.black,
                    ),
                    onPressed: () {
                        setState(() {
                            obscured = !obscured;
                        });
                    },
                ),
            ),
            obscureText: obscured,
            style: fieldStyle,
            strutStyle: fieldStrutStyle,
            onChanged: (String password) {
                _password = password;
            },
        ),
    );

    Widget get loginButton => Container(
        margin: const EdgeInsets.only(
            top: 30.0,
        ),
        height: 50.0,
        child: ClipRRect(
            borderRadius: BorderRadius.circular(30.0),
          child: FlatButton(
              highlightColor: Colors.grey[700],
              color: Theme.of(context).primaryColor,
              child: Center(
                  child: Text(
                      "Login",
                      style: Theme.of(context).textTheme.title.copyWith(
                          color: Colors.white,
                      ),
                  ),
              ),
              onPressed: () async {

              },
          ),
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
                        Positioned(
                            top: 200.0,
                            bottom: 0.0,
                            width: Screen.width,
                            child: Column(
                                children: <Widget>[
                                    Expanded(
                                        child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 40.0,
                                                vertical: 20.0,
                                            ),
                                            child: Column(
                                                children: <Widget>[
                                                    usernameField,
                                                    passwordField,
                                                    loginButton,
                                                ],
                                            ),
                                        ),
                                    ),
                                ],
                            ),
                        ),
                        cover,
                    ],
                ),
            ),
        );
    }
}
