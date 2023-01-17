import 'package:flutter/material.dart';

import '../../../common/theme.dart';

class StyledUnderlinedTextButton extends StatelessWidget {
  const StyledUnderlinedTextButton({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => TextButton(
        onPressed: onPressed,
        child: Text(
          text,
          style: theme.textTheme.bodySmall!.copyWith(
            fontStyle: FontStyle.italic,
            decoration: TextDecoration.underline,
          ),
        ),
      );
}
