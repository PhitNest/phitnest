import 'package:flutter/material.dart';

import 'text_styles.dart';

class BodyTextStyle extends BaseTextStyle {
  BodyTextStyle(
      {required TextSize size,
      Color color = Colors.black,
      FontWeight? weight,
      double? letterSpacing})
      : super(
            letterSpacing: letterSpacing,
            color: color,
            weight: weight,
            size: size,
            fontSizeMap: {
              TextSize.HUGE: 20.0,
              TextSize.LARGE: 18.0,
              TextSize.MEDIUM: 15.0,
              TextSize.SMALL: 14.0
            });
}
