import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:pull_to_refresh_notification/pull_to_refresh_notification.dart'
    as pTRN;

import 'package:gitcandies/constants/constants.dart';

class CandiesRefreshList extends StatelessWidget {
  final pTRN.RefreshCallback onRefresh;
  final Widget content;

  const CandiesRefreshList({
    Key key,
    @required this.onRefresh,
    @required this.content,
  }) : super(key: key);

  Widget refreshHeader(pTRN.PullToRefreshScrollNotificationInfo info) {
    double offset = info?.dragOffset ?? 0.0;
    pTRN.RefreshIndicatorMode mode = info?.mode;

    Widget child = GestureDetector(
      onTap: mode == pTRN.RefreshIndicatorMode.error
          ? info?.pullToRefreshNotificationState?.show
          : null,
      child: Container(
        alignment: Alignment.center,
        height: offset,
        width: double.infinity,
        child: Center(
          child: RefreshLogo(
            mode: mode,
            offset: offset,
          ),
        ),
      ),
    );

    return SliverToBoxAdapter(
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return pTRN.PullToRefreshNotification(
      onRefresh: onRefresh,
      maxDragOffset: suSetSp(kToolbarHeight * 1.5),
      child: CustomScrollView(
        physics: const ClampingScrollPhysics(),
        slivers: <Widget>[
          pTRN.PullToRefreshContainer(refreshHeader),
          content,
        ],
      ),
    );
  }
}

class RefreshLogo extends StatefulWidget {
  final double offset;
  final pTRN.RefreshIndicatorMode mode;

  const RefreshLogo({
    Key key,
    @required this.mode,
    @required this.offset,
  }) : super(key: key);

  @override
  _RefreshLogoState createState() => _RefreshLogoState();
}

class _RefreshLogoState extends State<RefreshLogo>
    with TickerProviderStateMixin {
  AnimationController rotateController;
  CurvedAnimation rotateCurveAnimation;
  Animation<double> rotateAnimation;
  double angle = 0.0;

  bool animating = false;

  @override
  void initState() {
    rotateController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    );
    rotateCurveAnimation = CurvedAnimation(
      parent: rotateController,
      curve: Curves.ease,
    );
    rotateAnimation = Tween(begin: 0.0, end: 2.0).animate(rotateCurveAnimation);
    super.initState();
  }

  void startAnimate() {
    animating = true;
    rotateController..repeat();
  }

  void stopAnimate() {
    animating = false;
    rotateController
      ..stop()
      ..reset();
  }

  Widget get logo => Image.asset(
        R.ASSETS_CANDIES_LOLLIPOP_WITHOUT_STICK_PNG,
        height: math.min(widget.offset, suSetSp(50.0)),
      );

  @override
  Widget build(BuildContext context) {
    if (!animating && widget.mode == pTRN.RefreshIndicatorMode.refresh) {
      startAnimate();
    } else if (widget.offset < 10.0 &&
        animating &&
        widget.mode != pTRN.RefreshIndicatorMode.refresh) {
      stopAnimate();
    }
    return Container(
        width: math.min(widget.offset, suSetSp(50)),
        height: math.min(widget.offset, suSetSp(50)),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
            ),
          ],
        ),
        child: Stack(
          overflow: Overflow.visible,
          children: <Widget>[
            Positioned(
              bottom: 0.0,
              left: 0.0,
              right: 0.0,
              child: Image.asset(
                R.ASSETS_CANDIES_LOLLIPOP_PNG,
              ),
            ),
            animating
                ? RotationTransition(
                    turns: rotateAnimation,
                    child: logo,
                  )
                : logo,
          ],
        ));
  }
}
