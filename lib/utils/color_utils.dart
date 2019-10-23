import 'package:flutter/material.dart';

class ColorUtils {
  ///
  /// get list of material color shades from simple [Color]
  ///
  static Map<int, Color> getMaterialColorValues(Color primary) => <int, Color>{
        50: getSwatchShade(primary, 50),
        100: getSwatchShade(primary, 100),
        200: getSwatchShade(primary, 200),
        300: getSwatchShade(primary, 300),
        400: getSwatchShade(primary, 400),
        500: getSwatchShade(primary, 500),
        600: getSwatchShade(primary, 600),
        700: getSwatchShade(primary, 700),
        800: getSwatchShade(primary, 800),
        900: getSwatchShade(primary, 900),
      };

  /// color a color shade for material swatch value
  static Color getSwatchShade(Color c, int swatchValue) {
    final hsl = HSLColor.fromColor(c);
    return hsl.withLightness(1 - (swatchValue / 1000)).toColor();
  }

  static MaterialColor newColorSwatch(Color color, {bool opaque: true}) {
    final c = opaque ? color.withOpacity(1.0) : color;
    final swatch = getMaterialColorValues(c);
    return new MaterialColor(c.value, swatch);
  }

  static MaterialColor swatchFor(Color color) =>
      Colors.primaries.firstWhere((c) => c.value == color.value,
          orElse: () => newColorSwatch(color));
}
