import 'package:display/display.dart';
import 'package:flutter/material.dart';

import '../../../constants/constants.dart';

class TextFieldInputDecoration extends InputDecoration {
  static final OutlineInputBorder errorColorBorder = OutlineInputBorder(
    borderSide: BorderSide(color: errorColor),
    borderRadius: BORDER_RADIUS,
  );

  TextFieldInputDecoration(String hint)
      : super(
            contentPadding: EdgeInsets.only(left: 16, right: 16),
            hintText: hint,
            focusedBorder: OutlineInputBorder(
                borderRadius: BORDER_RADIUS,
                borderSide:
                    BorderSide(color: Color(COLOR_PRIMARY), width: 2.0)),
            errorBorder: errorColorBorder,
            focusedErrorBorder: errorColorBorder,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade200),
              borderRadius: BORDER_RADIUS,
            ));
}
