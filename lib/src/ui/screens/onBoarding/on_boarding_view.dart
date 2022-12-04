import 'package:flutter/material.dart';

import '../view.dart';
import 'widgets/widgets.dart';

class OnBoardingView extends ScreenView {
  final VoidCallback onPressedYes;
  final VoidCallback onPressedNo;

  const OnBoardingView({
    required this.onPressedYes,
    required this.onPressedNo,
  }) : super();

  @override
  Widget build(BuildContext context) => Scaffold(
        body: PageView(
          children: [
            FirstPage(),
            SecondPage(),
            ThirdPage(
              onPressedYes: onPressedYes,
              onPressedNo: onPressedNo,
            )
          ],
        ),
      );
}
