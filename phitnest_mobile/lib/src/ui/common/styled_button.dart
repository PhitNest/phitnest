import 'package:flutter/material.dart';

class StyledButton extends TextButton {
  StyledButton(BuildContext context,
      {required super.onPressed,
      required super.child,
      Color backgroundColor = Colors.black,
      Color foregroundColor = Colors.white,
      EdgeInsets interiorPadding =
          const EdgeInsets.symmetric(horizontal: 30, vertical: 10)})
      : super(
          style: ButtonStyle(
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8))),
              padding: MaterialStateProperty.all(interiorPadding),
              backgroundColor: MaterialStateProperty.all(backgroundColor),
              foregroundColor: MaterialStateProperty.all(foregroundColor),
              textStyle: MaterialStateProperty.all(
                  Theme.of(context).textTheme.bodySmall)),
        );
}
