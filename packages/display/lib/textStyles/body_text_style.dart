import 'package:flutter/material.dart';

import '../display.dart';

class BodyTextStyle extends TextStyle {
  // Font sizes
  static const LARGE = 18.0;
  static const MEDIUM = 15.0;
  static const SMALL = 14.0;

  BodyTextStyle(
      {required Size size,
      Color? color,
      FontWeight? weight,
      double? letterSpacing})
      : super(
            letterSpacing: letterSpacing,
            color: color,
            fontWeight: weight,
            fontSize: size == Size.LARGE
                ? LARGE
                : size == Size.MEDIUM
                    ? MEDIUM
                    : SMALL);
}
