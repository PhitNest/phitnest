import 'package:flutter/material.dart';

import '../theme.dart';

class StyledOutlineButton extends ElevatedButton {
  final String? text;
  final void Function() onPress;

  StyledOutlineButton({
    super.key,
    required this.onPress,
    this.text,
  }) : super(
          onPressed: onPress,
          child: Text(
            text ?? '',
            style: AppTheme.instance.theme.textTheme.bodySmall,
          ),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.transparent),
            side: MaterialStateProperty.all(
              BorderSide(
                color: AppTheme.instance.theme.colorScheme.primary,
                width: 2,
              ),
            ),
          ),
        );
}
