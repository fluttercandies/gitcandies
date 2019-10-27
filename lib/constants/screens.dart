import 'dart:io';
import 'dart:ui' as ui show window;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:gitcandies/utils/utils.dart';

class Screen {
  static MediaQueryData mediaQuery = MediaQueryData.fromWindow(ui.window);

  static double get width => mediaQuery.size.width;

  static double get height => mediaQuery.size.height;

  static double get scale => mediaQuery.devicePixelRatio;

  static double get textScaleFactor => mediaQuery.textScaleFactor;

  static double get navigationBarHeight =>
      mediaQuery.padding.top + kToolbarHeight;

  static double get topSafeHeight => mediaQuery.padding.top;

  static double get bottomSafeHeight => mediaQuery.padding.bottom;

  static updateStatusBarStyle(SystemUiOverlayStyle style) {
    SystemChrome.setSystemUIOverlayStyle(style);
  }

  static double fixedFontSize(double fontSize) {
    return fontSize / textScaleFactor;
  }
}

/// Screen capability method.
double suSetSp(num size, {double scale = 1}) {
  double value = ScreenUtil.instance.setSp(size) * 1.8;
  if (Platform.isIOS) {
    if (ScreenUtil.screenWidthDp <= 414.0) {
      value = size / 1.2;
    } else if (ScreenUtil.screenWidthDp > 414.0 &&
        ScreenUtil.screenWidthDp > 750.0) {
      value = size;
    }
  }
  return value * scale;
}
