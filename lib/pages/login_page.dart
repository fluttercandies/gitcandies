import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:gitcandies/constants/constants.dart';
import 'package:gitcandies/providers/providers.dart';
import 'package:ff_annotation_route/ff_annotation_route.dart';

@FFRoute(name: "/loginpage", routeName: "登录页面")
class LoginPage extends StatefulWidget {
  final bool pushFromSplash;

  const LoginPage({
    Key key,
    this.pushFromSplash = false,
  }) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  bool covered = false;
  bool obscured = true;
  String _username, _password;

  double get buttonHeight => 46.0;

  TextStyle get fieldStyle => Theme.of(context).textTheme.body1.copyWith(
        fontSize: suSetSp(20.0),
        textBaseline: TextBaseline.alphabetic,
      );

  StrutStyle get fieldStrutStyle => StrutStyle(
        fontSize: suSetSp(20.0),
        height: suSetSp(1.5),
        forceStrutHeight: true,
      );

  @override
  void initState() {
    if (widget.pushFromSplash) covered = true;

    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (covered)
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
        duration: const Duration(seconds: 2),
        top: covered ? 0.0 : -Screen.height,
        curve: Curves.easeIn,
        width: Screen.width,
        height: Screen.height,
        child: Container(
          padding: EdgeInsets.all(suSetSp(80.0)),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
          ),
          child: Center(
            child: Image.asset(
              R.ASSETS_LOGO_FRONT_PNG,
              width: suSetSp(240.0),
            ),
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
        height: suSetSp(180.0),
        child: Center(
          child: Image.asset(
            R.ASSETS_CANDIES_LOGO_LOGO_WHITE_PNG,
            height: suSetSp(180 - kToolbarHeight),
          ),
        ),
      );

  Widget get content => Positioned(
        top: suSetSp(190.0),
        bottom: 0.0,
        width: Screen.width,
        child: basicLoginField,
      );

  Widget get basicLoginField => ListView(
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: suSetSp(40.0),
              vertical: suSetSp(20.0),
            ),
            child: Column(
              children: <Widget>[
                usernameField,
                passwordField,
                loginButton,
              ],
            ),
          ),
        ],
      );

  Widget get usernameField => Consumer<LoginProvider>(
        builder: (context, provider, _) => Container(
          child: TextField(
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                horizontal: suSetSp(6.0),
                vertical: suSetSp(10.0),
              ),
              labelText: "GitHub username",
              labelStyle: Theme.of(context).textTheme.body1.copyWith(
                    fontSize: suSetSp(16.0),
                  ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey[350],
                ),
              ),
              prefixIcon: Icon(Icons.person, size: suSetSp(24.0)),
            ),
            style: fieldStyle,
            strutStyle: fieldStrutStyle,
            onChanged: (String username) {
              _username = username;
            },
            autofocus: true,
            enabled: !provider.logging,
          ),
        ),
      );

  Widget get passwordField => Consumer<LoginProvider>(
        builder: (context, provider, _) => Container(
          child: TextField(
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                horizontal: suSetSp(6.0),
                vertical: suSetSp(10.0),
              ),
              labelText: "Password",
              labelStyle: Theme.of(context).textTheme.body1.copyWith(
                    fontSize: suSetSp(16.0),
                  ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey[350],
                ),
              ),
              prefixIcon: Icon(Icons.lock, size: suSetSp(16.0)),
              suffixIcon: IconButton(
                icon: Icon(
                  obscured ? Icons.visibility_off : Icons.visibility,
                  color: obscured ? Colors.grey[500] : Colors.black,
                  size: suSetSp(24.0),
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
            enabled: !provider.logging,
          ),
        ),
      );

  Widget get loginButton => Consumer<LoginProvider>(
        builder: (context, provider, _) {
          return AnimatedContainer(
            duration: kTabScrollDuration,
            margin: EdgeInsets.only(
              top: suSetSp(buttonHeight / 2),
            ),
            width: provider.logging ? suSetSp(100.0) : Screen.width,
            height: buttonHeight,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(suSetSp(buttonHeight / 2)),
              child: Stack(
                children: <Widget>[
                  FlatButton(
                    splashColor: Colors.grey[700],
                    color: Theme.of(context).primaryColor,
                    child: Center(
                      child: AnimatedSwitcher(
                        child: !provider.logging
                            ? Text(
                                "Login",
                                style:
                                    Theme.of(context).textTheme.title.copyWith(
                                          color: Colors.white,
                                          fontSize: suSetSp(21.0),
                                        ),
                              )
                            : SizedBox(
                                width: suSetSp(24.0),
                                height: suSetSp(24.0),
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.grey),
                                ),
                              ),
                        duration: kTabScrollDuration,
                      ),
                    ),
                    onPressed: () async {
                      if (!provider.logging) {
                        provider.loginWithBasic(_username, _password);
                      }
                    },
                  ),
                  AnimatedSwitcher(
                    duration: kTabScrollDuration,
                    child: provider.logging
                        ? Stack(
                            children: <Widget>[
                              Waver(
                                size: Size(Screen.width, buttonHeight),
                                color: Colors.grey.withAlpha(50),
                                duration: const Duration(seconds: 4),
                              ),
                              Waver(
                                size: Size(Screen.width, buttonHeight),
                                color: Colors.grey.withAlpha(50),
                                duration: const Duration(seconds: 3),
                                xOffset: 30,
                              ),
                              Waver(
                                size: Size(Screen.width, buttonHeight),
                                color: Colors.grey.withAlpha(50),
                                duration: const Duration(seconds: 2),
                                xOffset: 60,
                              ),
                            ],
                          )
                        : SizedBox.shrink(),
                  ),
                ],
              ),
            ),
          );
        },
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          waver,
          header,
          content,
          cover,
        ],
      ),
    );
  }
}
