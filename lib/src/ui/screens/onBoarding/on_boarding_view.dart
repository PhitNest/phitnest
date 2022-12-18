import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../view.dart';
import 'widgets/widgets.dart';

class OnBoardingView extends ScreenView {
  final VoidCallback onPressedYes;

  const OnBoardingView({
    required this.onPressedYes,
  }) : super();

  @override
  Widget build(BuildContext context) => AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Scaffold(
          body: PageView(
            children: [
              FirstPage(),
              SecondPage(),
              ThirdPage(
                onPressedYes: onPressedYes,
              )
            ],
          ),
        ),
      );
}
