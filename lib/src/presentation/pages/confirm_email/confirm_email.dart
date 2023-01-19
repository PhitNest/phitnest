import 'package:flutter/material.dart';

class ConfirmEmailPage extends StatelessWidget {
  final String email;

  const ConfirmEmailPage({Key? key, required this.email}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Confirm Email Page'),
      ),
    );
  }
}
