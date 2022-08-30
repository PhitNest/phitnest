import 'package:flutter/material.dart';

class StyledButton extends TextButton {
  StyledButton(BuildContext context,
      {required super.onPressed, required String text})
      : super(
          child: Text(text),
          style: ButtonStyle(
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8))),
              padding: MaterialStateProperty.all(
                  EdgeInsets.symmetric(horizontal: 30, vertical: 10)),
              backgroundColor: MaterialStateProperty.all(Colors.black),
              foregroundColor: MaterialStateProperty.all(Colors.white),
              textStyle: MaterialStateProperty.all(TextStyle(
                  fontSize: 12,
                  fontFamily: 'Metropolis',
                  letterSpacing: 0.02))),
        );

  StyledButton.red(BuildContext context,
      {required super.onPressed, required String text})
      : super(
          child: Text(text),
          style: ButtonStyle(
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8))),
              padding: MaterialStateProperty.all(
                  EdgeInsets.symmetric(horizontal: 30, vertical: 10)),
              backgroundColor: MaterialStateProperty.all(Colors.red),
              foregroundColor: MaterialStateProperty.all(Colors.white),
              textStyle: MaterialStateProperty.all(TextStyle(
                  fontSize: 12,
                  fontFamily: 'Metropolis',
                  letterSpacing: 0.02))),
        );
}
