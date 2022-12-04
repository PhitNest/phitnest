import 'package:flutter/material.dart';

import '../theme.dart';

class TextButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const TextButtonWidget({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => TextButton(
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.transparent),
        ),
        child: Text(
          text,
          style: theme.textTheme.bodySmall!.copyWith(
            color: Colors.black,
            fontStyle: FontStyle.italic,
            decoration: TextDecoration.underline,
          ),
        ),
      );
}
