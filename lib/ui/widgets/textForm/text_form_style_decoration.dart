import 'package:display/display.dart';
import 'package:flutter/material.dart';

import '../../../../constants/constants.dart';

final OutlineInputBorder errorBorder = OutlineInputBorder(
  borderSide: BorderSide(color: errorColor),
  borderRadius: BORDER_RADIUS,
);

class TextFormStyleDecoration extends InputDecoration {
  TextFormStyleDecoration({String? hint})
      : super(
            contentPadding: EdgeInsets.only(left: 16, right: 16),
            hintText: hint,
            focusedBorder: OutlineInputBorder(
                borderRadius: BORDER_RADIUS,
                borderSide:
                    BorderSide(color: Color(COLOR_PRIMARY), width: 2.0)),
            errorBorder: errorBorder,
            focusedErrorBorder: errorBorder,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade200),
              borderRadius: BORDER_RADIUS,
            ));
}
