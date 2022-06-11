import 'package:device/device.dart';
import 'package:flutter/material.dart';

final OutlineInputBorder errorBorder = OutlineInputBorder(
  borderSide: BorderSide(color: errorColor),
  borderRadius: borderRadius,
);

class TextFormStyleDecoration extends InputDecoration {
  TextFormStyleDecoration({String? hint, TextStyle? hintStyle})
      : super(
            contentPadding: EdgeInsets.only(
              left: 12,
              bottom: 12,
              right: 12,
            ),
            hintText: hint,
            hintStyle: hintStyle,
            focusedBorder: UnderlineInputBorder(
                borderRadius: borderRadius,
                borderSide: BorderSide(color: primaryColor, width: 2.0)),
            errorBorder: errorBorder,
            focusedErrorBorder: errorBorder,
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey,
              ),
              borderRadius: borderRadius,
            ));
}
