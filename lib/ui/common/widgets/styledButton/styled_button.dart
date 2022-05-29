import 'package:device/device.dart';
import 'package:flutter/material.dart';

import '../../textStyles/text_styles.dart';

class StyledButton extends StatelessWidget {
  final double minWidth;
  final String text;
  final Color? buttonColor;
  final Color? textColor;
  final Function() onClick;
  final EdgeInsets padding;

  const StyledButton(
      {required Key key,
      required this.text,
      required this.onClick,
      this.textColor,
      this.buttonColor,
      this.padding = const EdgeInsets.all(5),
      this.minWidth = double.infinity})
      : super(key: key);

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
                size: TextSize.SMALL, color: textColor ?? Colors.white),
          ),
          onPressed: onClick,
        ),
      );
}
