import 'package:flutter/material.dart';

import 'package:gitav/pages/login_page.dart';


class RouteUtil {
    static Map<String, WidgetBuilder> get routes => {
        "/login": (_) => LoginPage(),
    };
}

class FadePageTransitionsBuilder extends PageTransitionsBuilder {
    const FadePageTransitionsBuilder();

    @override
    Widget buildTransitions<T>(
            PageRoute<T> route,
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
            ) {
        return FadePageTransition(routeAnimation: animation, child: child);
    }
}

class FadePageTransition extends StatelessWidget {
    FadePageTransition({
        Key key,
        @required Animation<double> routeAnimation,
        @required this.child,
    }) : _opacityAnimation = routeAnimation.drive(_easeInTween),
                super(key: key);

    static final Animatable<double> _easeInTween = CurveTween(curve: Curves.easeIn);

    final Animation<double> _opacityAnimation;
    final Widget child;

    @override
    Widget build(BuildContext context) {
        return FadeTransition(
            opacity: _opacityAnimation,
            child: child,
        );
    }
}
