import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'name/name.dart';

class OnBoardingIntroScreen extends StatelessWidget {
  const OnBoardingIntroScreen({super.key}) : super();

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () => Navigator.of(context).push(
                CupertinoPageRoute<void>(
                  builder: (context) => const OnBoardingNameScreen(),
                ),
              ),
              child: const Text("LET'S GET STARTED"),
            ),
            TextButton(
              onPressed: () {},
              child: const Text('I already have an account'),
            ),
          ],
        ),
      );
}
