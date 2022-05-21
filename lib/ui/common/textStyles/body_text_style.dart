import 'package:flutter/material.dart';

import 'text_styles.dart';

class BodyTextStyle extends TextStyle {
  // Font sizes
  static const LARGE = 18.0;
  static const MEDIUM = 15.0;
  static const SMALL = 14.0;

  BodyTextStyle(
      {required TextSize size,
      Color? color,
      FontWeight? weight,
      double? letterSpacing})
      : super(
            letterSpacing: letterSpacing,
            color: color,
            fontWeight: weight,
            fontSize: size == TextSize.LARGE
                ? LARGE
                : size == TextSize.MEDIUM
                    ? MEDIUM
                    : SMALL);
}
