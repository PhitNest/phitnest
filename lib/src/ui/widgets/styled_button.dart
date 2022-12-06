import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme.dart';

class StyledButton extends StatelessWidget {
  final EdgeInsets? interiorPadding;
  final Color backgroundColor;
  final Color foregroundColor;
  final Widget child;
  final VoidCallback onPressed;

  StyledButton({
    required this.onPressed,
    required this.child,
    this.backgroundColor = Colors.black,
    this.foregroundColor = Colors.white,
    this.interiorPadding,
  }) : super();

  @override
  Widget build(BuildContext context) => TextButton(
        child: child,
        onPressed: onPressed,
        style: ButtonStyle(
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          minimumSize: MaterialStateProperty.all(Size.zero),
          padding: MaterialStateProperty.all(
            interiorPadding ??
                EdgeInsets.symmetric(horizontal: 30.w, vertical: 10.h),
          ),
          backgroundColor: MaterialStateProperty.all(backgroundColor),
          foregroundColor: MaterialStateProperty.all(foregroundColor),
          textStyle: MaterialStateProperty.all(theme.textTheme.bodySmall),
        ),
      );
}
