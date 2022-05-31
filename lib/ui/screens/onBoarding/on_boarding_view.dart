import 'package:flutter/material.dart';
import 'package:liquid_swipe/liquid_swipe.dart';

import '../views.dart';

class OnBoardingView extends BaseView {
  final List<Widget> pages;
  final LiquidController controller = LiquidController();

  OnBoardingView({Key? key, required this.pages}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        body: LiquidSwipe(
          liquidController: controller,
          pages: pages,
          enableLoop: false,
        ),
      );
}
