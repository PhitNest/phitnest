import 'package:flutter/material.dart';

class ConfirmEmailPage extends StatelessWidget {
  final String email;
  final String password;

  const ConfirmEmailPage({
    Key? key,
    required this.email,
    required this.password,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Confirm Email Page'),
      ),
    );
  }
}
