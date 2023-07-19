import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme.dart';

final class StyledOutlineButton extends ElevatedButton {
  final String? text;
  final double? hPadding;
  final double? vPadding;
  final void Function() onPress;

  StyledOutlineButton({
    super.key,
    required this.onPress,
    this.text,
    this.hPadding,
    this.vPadding,
  }) : super(
          onPressed: onPress,
          child: Text(
            text ?? '',
            style: theme.textTheme.bodySmall,
          ),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.transparent),
            padding: MaterialStateProperty.all(
              EdgeInsets.symmetric(
                horizontal: hPadding ?? 31.5.w,
                vertical: vPadding ?? 18.h,
              ),
            ),
            side: MaterialStateProperty.all(
              BorderSide(
                color: theme.colorScheme.primary,
                width: 2,
              ),
            ),
          ),
        );
}
