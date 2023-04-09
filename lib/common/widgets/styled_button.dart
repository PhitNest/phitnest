import 'package:flutter/material.dart';

import '../../theme.dart';

class StyledButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool darkMode;

  const StyledButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.darkMode = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => TextButton(
        key: key,
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.all(darkMode ? Colors.white : Colors.black),
          foregroundColor:
              MaterialStateProperty.all(darkMode ? Colors.black : Colors.white),
          padding: MaterialStateProperty.all(
            const EdgeInsets.symmetric(vertical: 18, horizontal: 48),
          ),
          textStyle: MaterialStateProperty.all(theme.textTheme.bodySmall!),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        child: Text(text,
            style: theme.textTheme.labelMedium!
                .copyWith(color: darkMode ? Colors.black : Colors.white)),
      );
}
