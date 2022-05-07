import 'package:flutter/material.dart';

import '../display.dart';

class HeadingTextStyle extends TextStyle {
  // Font sizes
  static const HEADER_SIZE_LARGE = 25.0;
  static const HEADER_SIZE_MEDIUM = 24.0;
  static const HEADER_SIZE_SMALL = 20.0;

  HeadingTextStyle({required Size size, Color? color})
      : super(
            color: color ?? primaryColor,
            fontWeight: FontWeight.bold,
            fontSize: size == Size.LARGE
                ? HEADER_SIZE_LARGE
                : size == Size.MEDIUM
                    ? HEADER_SIZE_MEDIUM
                    : HEADER_SIZE_SMALL);
}
