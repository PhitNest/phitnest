import 'package:flutter/material.dart';
import 'package:liquid_swipe/liquid_swipe.dart';

import '../base_view.dart';

/// View for the on boarding screen
class OnBoardingView extends BaseView {
  /// The list of pages generated and given to us by the provider
  final List<Widget> pages;

  /// This is mostly necessary for integration tests
  final LiquidController controller = LiquidController();

  OnBoardingView({Key? key, required this.pages}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        // Awesome transition package
        body: LiquidSwipe(
          liquidController: controller,
          pages: pages,
          enableLoop: false,
        ),
      );
}
