import 'package:device/device.dart';
import 'package:flutter/material.dart';

import 'text_styles.dart';

class HeadingTextStyle extends BaseTextStyle {
  HeadingTextStyle(
      {required TextSize size,
      Color? color,
      FontWeight? weight = FontWeight.bold,
      double? letterSpacing})
      : super(
            color: color ?? primaryColor,
            weight: weight,
            letterSpacing: letterSpacing,
            size: size,
            fontSizeMap: {
              TextSize.HUGE: 32.0,
              TextSize.LARGE: 25.0,
              TextSize.MEDIUM: 24.0,
              TextSize.SMALL: 20.0
            });
}
