import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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

  static double get safeHeight => height - topSafeHeight - bottomSafeHeight;

  static updateStatusBarStyle(SystemUiOverlayStyle style) {
    SystemChrome.setSystemUIOverlayStyle(style);
  }

  static double fixedFontSize(double fontSize) {
    return fontSize / textScaleFactor;
  }
}

///
/// Screen capability method.
///
double suSetSp(double size, {double scale}) =>
    _sizeCapable(ScreenUtil.getInstance().setSp(size) * 2, scale: scale);

double suSetWidth(double size, {double scale}) =>
    _sizeCapable(ScreenUtil.getInstance().setWidth(size) * 2, scale: scale);

double suSetHeight(double size, {double scale}) =>
    _sizeCapable(ScreenUtil.getInstance().setHeight(size) * 2, scale: scale);

double _sizeCapable(double size, {double scale}) =>
    size * (scale ?? 1.0);
