import 'package:flutter/material.dart';

final class LoginButton extends StatelessWidget {
  final void Function() onSubmit;

  const LoginButton({
    super.key,
    required this.onSubmit,
  }) : super();

  @override
  Widget build(BuildContext context) => MaterialButton(
        onPressed: onSubmit,
        color: Colors.black,
        textColor: Colors.white,
        child: const Text(
          'Login',
        ),
      );
}
