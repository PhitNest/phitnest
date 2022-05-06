import 'package:display/display.dart';
import 'package:flutter/material.dart';

import '../../../constants/constants.dart';

enum Size { LARGE, MEDIUM, SMALL }

class HeadingTextStyle extends TextStyle {
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
