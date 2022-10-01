import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StyledButton extends StatelessWidget {
  final EdgeInsets? interiorPadding;
  final Color backgroundColor;
  final Color foregroundColor;
  final Widget child;
  final Function() onPressed;

  StyledButton(
      {required this.onPressed,
      required this.child,
      this.backgroundColor = Colors.black,
      this.foregroundColor = Colors.white,
      this.interiorPadding})
      : super();

  @override
  Widget build(BuildContext context) => TextButton(
        child: child,
        onPressed: onPressed,
        style: ButtonStyle(
            shape: MaterialStateProperty.all(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
            padding: MaterialStateProperty.all(interiorPadding ??
                EdgeInsets.symmetric(horizontal: 30.w, vertical: 10.h)),
            backgroundColor: MaterialStateProperty.all(backgroundColor),
            foregroundColor: MaterialStateProperty.all(foregroundColor),
            textStyle: MaterialStateProperty.all(
                Theme.of(context).textTheme.bodySmall)),
      );
}
