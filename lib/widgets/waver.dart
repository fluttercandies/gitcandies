
import 'dart:math' as math;
import 'package:vector_math/vector_math.dart' as Vector;

import 'package:flutter/material.dart';


class Waver extends StatefulWidget {
    final Size size;
    final int xOffset;
    final int yOffset;
    final Color color;
    final Duration duration;
    final double opacity;

    Waver({
        Key key,
        @required this.size,
        this.xOffset = 0,
        this.yOffset = 0,
        @required this.color,
        this.duration,
        this.opacity,
    }) : super(key: key);

    @override
    State<StatefulWidget> createState() {
        return _WaverState();
    }
}

class _WaverState extends State<Waver> with TickerProviderStateMixin {
    AnimationController animationController;
    List<Offset> animationList = [];

    @override
    void initState() {
        animationController = AnimationController(
            vsync: this, duration: widget.duration ?? const Duration(seconds: 10),
        );

        animationController.addListener(() {
            animationList.clear();
            for (int i = -2 - widget.xOffset; i <= widget.size.width.toInt() + 2; i++) {
                animationList.add(Offset(
                        i.toDouble() + widget.xOffset,
                        widget.size.height + math.sin(
                                (animationController.value * 360 - i) %
                                        360 * Vector.degrees2Radians
                        ) * 20 - 30 - widget.yOffset
                ));
            }
        });
        animationController.repeat();
        super.initState();
    }

    @override
    void dispose() {
        animationController.dispose();
        super.dispose();
    }

    @override
    Widget build(BuildContext context) {
        Widget waver = Align(
            alignment: Alignment.center,
            child: AnimatedBuilder(
                animation: CurvedAnimation(
                    parent: animationController,
                    curve: Curves.easeInOut,
                ),
                builder: (context, child) => ClipPath(
                    child: Container(
                        width: widget.size.width,
                        height: widget.size.height,
                        color: widget.color,
                    ),
                    clipper: WaveClipper(animationController.value, animationList),
                ),
            ),
        );
        if (widget.opacity != null) waver = Opacity(
            opacity: widget.opacity,
            child: waver,
        );
        return waver;
    }
}


class WaveClipper extends CustomClipper<Path> {
    final double animation;

    List<Offset> waveList = [];

    WaveClipper(this.animation, this.waveList);

    @override
    Path getClip(Size size) {
        Path path = Path();

        path.addPolygon(waveList, false);
        path.lineTo(size.width, 0.0);
        path.lineTo(0.0, 0.0);
        path.close();
        return path;
    }

    @override
    bool shouldReclip(WaveClipper oldClipper) => animation != oldClipper.animation;
}