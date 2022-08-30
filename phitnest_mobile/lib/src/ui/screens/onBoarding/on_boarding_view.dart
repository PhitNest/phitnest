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
        IntroPage(
            title: 'Welcome to the Nest.',
            subtitle: 'This is the beginning of\na beautiful friendship.'),
        IntroPage(
            title: 'Nest = fitness club',
            subtitle:
                'This is a positive space for you to\nexplore your health & wellness\ngoals through genuine\nconnections in your community.'),
        PageThree(
          onPressedYes: onPressedYes,
          onPressedNo: onPressedNo,
        )
      ]));
}
