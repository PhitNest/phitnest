import 'package:display/display.dart';
import 'package:flutter/material.dart';

class StyledButton extends StatelessWidget {
  final double minWidth;
  final String text;
  final Color? buttonColor;
  final Color? textColor;
  final Function() onClick;
  final EdgeInsets padding;

  StyledButton(
      {required this.text,
      required this.onClick,
      this.textColor,
      this.buttonColor,
      this.padding = const EdgeInsets.all(5),
      this.minWidth = double.infinity});

  @override
  Widget build(BuildContext context) => Container(
        padding: padding,
        constraints: BoxConstraints(minWidth: minWidth),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              primary: buttonColor ?? primaryColor,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: borderRadius,
                  side: BorderSide(
                    color: primaryColor,
                  ))),
          child: Text(
            text,
            style: HeadingTextStyle(
                size: Size.SMALL, color: textColor ?? Colors.white),
          ),
          onPressed: onClick,
        ),
      );
}
