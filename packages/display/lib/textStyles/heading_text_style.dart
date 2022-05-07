import 'package:flutter/material.dart';

import '../display.dart';

class HeadingTextStyle extends TextStyle {
  // Font sizes
  static const LARGE = 25.0;
  static const MEDIUM = 24.0;
  static const SMALL = 20.0;

  HeadingTextStyle({required Size size, Color? color})
      : super(
            color: color ?? primaryColor,
            fontWeight: FontWeight.bold,
            fontSize: size == Size.LARGE
                ? LARGE
                : size == Size.MEDIUM
                    ? MEDIUM
                    : SMALL);
}
