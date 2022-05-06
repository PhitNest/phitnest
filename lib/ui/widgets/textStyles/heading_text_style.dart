import 'package:flutter/material.dart';

import '../../../constants/constants.dart';

enum Size { LARGE, MEDIUM, SMALL }

class HeadingTextStyle extends TextStyle {
  HeadingTextStyle(Size size)
      : super(
            color: Color(COLOR_PRIMARY),
            fontWeight: FontWeight.bold,
            fontSize: size == Size.LARGE
                ? 25.0
                : size == Size.MEDIUM
                    ? 24.0
                    : 20.0);
}
