import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../login/ui.dart';
import '../register/ui.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key}) : super();

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () => Navigator.of(context).push(
                CupertinoPageRoute<void>(
                  builder: (context) => const RegisterScreen(),
                ),
              ),
              child: const Text("LET'S GET STARTED"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).push(
                CupertinoPageRoute<void>(
                  builder: (context) => const LoginScreen(),
                ),
              ),
              child: const Text('I already have an account'),
            ),
          ],
        ),
      );
}
