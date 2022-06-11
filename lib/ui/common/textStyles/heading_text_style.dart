import 'package:device/device.dart';
import 'package:flutter/material.dart';

import 'text_styles.dart';

class HeadingTextStyle extends TextStyle {
  // Font sizes
  static const HUGE = 32.0;
  static const LARGE = 25.0;
  static const MEDIUM = 24.0;
  static const SMALL = 20.0;

  HeadingTextStyle({required TextSize size, Color? color})
      : super(
            color: color ?? primaryColor,
            fontWeight: FontWeight.bold,
            fontSize: size == TextSize.HUGE
                ? HUGE
                : size == TextSize.LARGE
                    ? LARGE
                    : size == TextSize.MEDIUM
                        ? MEDIUM
                        : SMALL);
}
