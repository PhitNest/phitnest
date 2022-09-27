import 'package:flutter/material.dart';

import '../view.dart';
import 'pages/pages.dart';

class OnBoardingView extends ScreenView {
  final Function() onPressedYes;
  final Function() onPressedNo;

  const OnBoardingView({required this.onPressedYes, required this.onPressedNo})
      : super();

  @override
  Widget build(BuildContext context) => Scaffold(
          body: PageView(children: [
        FirstPage(),
        SecondPage(),
        ThirdPage(
          onPressedYes: onPressedYes,
          onPressedNo: onPressedNo,
        )
      ]));
}
