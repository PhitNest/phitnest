import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StyledButton extends TextButton {
  StyledButton(BuildContext context,
      {required super.onPressed,
      required super.child,
      Color backgroundColor = Colors.black,
      Color foregroundColor = Colors.white,
      EdgeInsets? interiorPadding})
      : super(
          style: ButtonStyle(
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8))),
              padding: MaterialStateProperty.all(interiorPadding ??
                  EdgeInsets.symmetric(horizontal: 30.w, vertical: 10.h)),
              backgroundColor: MaterialStateProperty.all(backgroundColor),
              foregroundColor: MaterialStateProperty.all(foregroundColor),
              textStyle: MaterialStateProperty.all(
                  Theme.of(context).textTheme.bodySmall)),
        );
}
