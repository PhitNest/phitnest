import 'package:device/device.dart';
import 'package:flutter/material.dart';

final OutlineInputBorder errorBorder = OutlineInputBorder(
  borderSide: BorderSide(color: errorColor),
  borderRadius: borderRadius,
);

class TextFormStyleDecoration extends InputDecoration {
  TextFormStyleDecoration({String? hint})
      : super(
            contentPadding: EdgeInsets.only(left: 16, right: 16),
            hintText: hint,
            focusedBorder: OutlineInputBorder(
                borderRadius: borderRadius,
                borderSide: BorderSide(color: primaryColor, width: 2.0)),
            errorBorder: errorBorder,
            focusedErrorBorder: errorBorder,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade200),
              borderRadius: borderRadius,
            ));
}
