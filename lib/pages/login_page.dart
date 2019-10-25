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
        fontSize: 20.0,
        textBaseline: TextBaseline.alphabetic,
      );

  StrutStyle get fieldStrutStyle => StrutStyle(
        fontSize: 20.0,
        height: 1.5,
        forceStrutHeight: true,
      );

  Animation<double> candieAnimation;
  AnimationController candieAnimationController;

  @override
  void initState() {
    if (widget.pushFromSplash) covered = true;

    candieAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    candieAnimation =
        Tween(begin: 0.0, end: 1.0).animate(candieAnimationController);

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
    candieAnimationController..stop()..reset()..dispose();
    super.dispose();
  }

  Widget get cover => AnimatedPositioned(
        duration: const Duration(seconds: 2),
        top: covered ? 0.0 : -Screen.height,
        curve: Curves.easeIn,
        width: Screen.width,
        height: Screen.height,
        child: Container(
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
        child: Center(
          child: Image.asset(
            R.ASSETS_CANDIES_LOGO_LOGO_WHITE_PNG,
            height: 180 - kToolbarHeight,
          ),
        ),
      );

  Widget get content => Positioned(
        top: 200.0,
        bottom: 0.0,
        width: Screen.width,
        child: basicLoginField,
      );

  Widget get basicLoginField => Column(
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
                  fontSize: 16.0,
                ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey[350],
              ),
            ),
            prefixIcon: Icon(Icons.person),
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
                  fontSize: 16.0,
                ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey[350],
              ),
            ),
            prefixIcon: Icon(Icons.lock),
            suffixIcon: IconButton(
              icon: Icon(
                obscured ? Icons.visibility_off : Icons.visibility,
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

  Widget get loginButton => Consumer<LoginProvider>(
        builder: (context, provider, _) {
          return AnimatedContainer(
            duration: kTabScrollDuration,
            margin: EdgeInsets.only(
              top: buttonHeight / 2,
            ),
            height: buttonHeight,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(buttonHeight / 2),
              child: FlatButton(
                splashColor: Colors.grey[700],
                color: Theme.of(context).primaryColor,
                child: Center(
                  child: AnimatedCrossFade(
                      firstChild: Text(
                        "Login",
                        style: Theme.of(context).textTheme.title.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      secondChild: candie,
                      crossFadeState: !provider.logging ? CrossFadeState
                          .showFirst : CrossFadeState.showSecond,
                      duration: kTabScrollDuration,
                  ),
                ),
                onPressed: () async {
                  if (!provider.logging) {
                    provider.loginWithBasic(_username, _password);
                  }
                },
              ),
            ),
          );
        },
      );

  Future _loginAnimation(bool start) async {
    if (start && !candieAnimationController.isAnimating) {
      try {
        await candieAnimationController.repeat().orCancel;
      } on TickerCanceled {}
    } else if (!start) {
      candieAnimationController
        ..stop()
        ..reset();
    }
  }

  Widget get candie => RotationTransition(
        turns: candieAnimation,
    child: Image.asset(R.ASSETS_CANDIES_CANDIES_PNG, width: 40.0),
  );

  @override
  Widget build(BuildContext context) {
    return Consumer<LoginProvider>(
      builder: (context, provider, _) {
        _loginAnimation(provider.logging);
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
      },
    );
  }
}
