export 'heading_text_style.dart';
export 'body_text_style.dart';

import 'package:flutter/material.dart';

enum TextSize { HUGE, LARGE, MEDIUM, SMALL }

abstract class BaseTextStyle extends TextStyle {
  BaseTextStyle(
      {required TextSize size,
      required Map<TextSize, double> fontSizeMap,
      Color color = Colors.black,
      FontWeight? weight,
      double? letterSpacing})
      : super(
            color: color,
            fontWeight: weight,
            letterSpacing: letterSpacing,
            fontSize: fontSizeMap[size]);
}
