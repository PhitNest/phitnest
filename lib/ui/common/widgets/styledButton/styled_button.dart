import 'package:flutter/material.dart';
import 'package:phitnest/constants/constants.dart';

import '../../textStyles/text_styles.dart';

class StyledButton extends StatelessWidget {
  final double minWidth;
  final String text;
  final Color buttonColor;
  final Color buttonOutline;
  final Color textColor;
  final Function() onClick;
  final EdgeInsets padding;

  const StyledButton(
      {required Key key,
      required this.text,
      required this.onClick,
      this.textColor = Colors.black,
      this.buttonColor = kColorButton,
      this.buttonOutline = kColorButton,
      this.padding = const EdgeInsets.all(5),
      this.minWidth = 0})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        padding: padding,
        constraints: BoxConstraints(minWidth: minWidth),
        child: RawMaterialButton(
          elevation: 2.3,
          fillColor: buttonColor,
          padding: const EdgeInsets.symmetric(vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.0),
            side: BorderSide(
              color: buttonOutline,
            ),
          ),
          child: Text(
            text,
            style: BodyTextStyle(
              weight: FontWeight.bold,
              size: TextSize.LARGE,
              color: textColor,
            ),
          ),
          onPressed: onClick,
        ),
      );
}
