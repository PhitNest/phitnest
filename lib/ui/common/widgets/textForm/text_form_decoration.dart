import 'package:flutter/material.dart';
import 'package:phitnest/constants/constants.dart';

final OutlineInputBorder errorBorder = OutlineInputBorder(
  borderSide: BorderSide(color: Colors.red),
  borderRadius: BorderRadius.circular(24.0),
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
                borderRadius: BorderRadius.circular(24.0),
                borderSide: BorderSide(color: kColorPrimary, width: 2.0)),
            errorBorder: errorBorder,
            focusedErrorBorder: errorBorder,
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey,
              ),
              borderRadius: BorderRadius.circular(24.0),
            ));
}
