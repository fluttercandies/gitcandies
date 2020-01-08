import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:gitcandies/constants/constants.dart';

class LoadingIndicator extends StatelessWidget {
  final double strokeWidth;
  final Color color;
  final double value;

  const LoadingIndicator({
    Key key,
    this.strokeWidth = 4.0,
    this.color,
    this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return UnconstrainedBox(
      child: Platform.isIOS
          ? CupertinoActivityIndicator()
          : CircularProgressIndicator(
              strokeWidth: suSetWidth(strokeWidth),
              valueColor:
                  color != null ? AlwaysStoppedAnimation<Color>(color) : null,
              value: value,
            ),
    );
  }
}
