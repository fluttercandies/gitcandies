import 'package:flutter/material.dart';

import 'package:gitcandies/constants/constants.dart';
import 'package:gitcandies/pages/login_page.dart';

class RouteUtils {
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
  })  : _opacityAnimation = routeAnimation.drive(_easeInTween),
        super(key: key);

  static final Animatable<double> _easeInTween =
      CurveTween(curve: Curves.easeIn);

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

class RouteHelper {
  static RouteHelper _instance = RouteHelper._();

  RouteHelper._();

  factory RouteHelper() {
    return _instance;
  }

  /// 设置给 application 以获取一个全局单例的key, 可以在无context的情况下导航页面
  GlobalKey<NavigatorState> get navigatorKey => Constants.navigatorKey;

  NavigatorState get router => navigatorKey.currentState;

  BuildContext get context => navigatorKey.currentContext;

  /// 包含了一些常见的路由动画封装, 主要是用于dialog
  RouteAnimationHelper animationHelper = RouteAnimationHelper();

  /// push 一个 widget page.
  /// [replaceRoot] 为替换根路由
  /// [replaceCurrent] 替换当前路由页
  /// [result] 如果不存在 replace 的行为, 则忽略, 存在替换行为, 则将结果返回给上一个页面
  Future<T> pushWidget<T>(
    Widget widget, {
    bool replaceRoot = false,
    bool replaceCurrent = false,
    dynamic result,
  }) {
    final route = MaterialPageRoute(
      builder: (ctx) => widget,
      settings: RouteSettings(
        name: replaceRoot ? "/" : widget.runtimeType.toString(),
      ),
    );

    return pushRoute(
      route,
      replaceRoot: replaceRoot,
      replaceCurrent: replaceCurrent,
      result: result,
    );
  }

  /// push 一个route, 参数参考 [pushWidget]
  Future<T> pushRoute<T>(
    Route route, {
    bool replaceRoot = false,
    bool replaceCurrent = false,
    dynamic result,
  }) {
    if (replaceRoot) {
      return this.replaceRoot(route, result);
    }
    if (replaceCurrent) {
      return this.replaceCurrent(route, result);
    }
    return router.push(route);
  }

  /// 替换根布局的具体方法
  Future<T> replaceRoot<T>(Route route, [dynamic result]) {
    final rootRoute = ModalRoute.withName("/");
    this.router.popUntil(rootRoute);
    return this.router.pushReplacement(route, result: result);
  }

  Future<T> replaceCurrent<T>(Route route, [dynamic result]) {
    return this.router.pushReplacement(route, result: result);
  }

  /// 返回页
  void pop<T>([T value]) {
    router.pop(value);
  }

  Future<T> pushNamed<T>(
    String routeName, [
    Object args,
  ]) {
    return router.pushNamed(routeName, arguments: args);
  }

  Future<T> popAndPushNamed<T>(
    String routeName, {
    T result,
    Object args,
  }) {
    return router.popAndPushNamed(routeName, arguments: args, result: result);
  }

  Future<T> showDialog<T>(
    Widget dialog, {
    RouteTransitionsBuilder routeTransitionsBuilder,
  }) {
    return router.push<T>(
      DialogRoute<T>(
        dialogBuilder: (
          BuildContext context,
          Animation animation,
          Animation secondaryAnimation,
        ) {
          return GestureDetector(
            onTap: () => pop(),
            child: dialog,
          );
        },
        transitionBuilder: routeTransitionsBuilder,
      ),
    );
  }
}

class RouteAnimationHelper {
  Widget bottomAnim(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FractionalTranslation(
      translation: Offset(0, 1 - animation.value),
      child: child,
    );
  }

  Widget opacity(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return Opacity(
      child: child,
      opacity: animation.value,
    );
  }
}

class DialogRoute<T> extends PopupRoute<T> {
  final bool barrierDismissible;
  final Color barrierColor;
  final Duration transitionDuration;

  final RoutePageBuilder dialogBuilder;
  final RouteTransitionsBuilder transitionBuilder;

  DialogRoute({
    @required this.dialogBuilder,
    this.barrierDismissible = true,
    this.barrierColor = const Color(0x88000000),
    this.transitionDuration = const Duration(milliseconds: 288),
    this.transitionBuilder,
  });

  @override
  String get barrierLabel => "dialog_route";

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return dialogBuilder(context, animation, secondaryAnimation);
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    if (transitionBuilder == null) {
      return FadeTransition(
          opacity: CurvedAnimation(
            parent: animation,
            curve: Curves.linear,
          ),
          child: child);
    } // Some default transition
    return transitionBuilder(context, animation, secondaryAnimation, child);
  }

  @override
  bool get opaque => false;
}
