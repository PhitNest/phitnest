import 'package:flutter/material.dart';

import '../view.dart';
import 'widgets/pages.dart';

class OnBoardingView extends ScreenView {
  final Function() onPressedYes;
  final Function() onPressedNo;

  const OnBoardingView({required this.onPressedYes, required this.onPressedNo})
      : super();

  @override
  Widget buildView(BuildContext context) => Scaffold(
          body: PageView(
        children: [
          FirstPage(),
          SecondPage(),
          ThirdPage(
            onPressedYes: onPressedYes,
            onPressedNo: onPressedNo,
          )
        ],
      ));
}
