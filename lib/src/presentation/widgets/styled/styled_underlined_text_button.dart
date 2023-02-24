import 'package:flutter/material.dart';

import '../../../common/theme.dart';

class StyledUnderlinedTextButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool darkMode;

  const StyledUnderlinedTextButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.darkMode = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => TextButton(
        onPressed: onPressed,
        child: Text(
          text,
          style: theme.textTheme.bodySmall!.copyWith(
            fontStyle: FontStyle.italic,
            decoration: TextDecoration.underline,
            color: darkMode ? Colors.white : Colors.black,
          ),
        ),
      );
}
