import 'package:flutter/material.dart';

import '../../common/widgets.dart';
import '../screens.dart';
import '../provider.dart';
import 'on_boarding_state.dart';
import 'on_boarding_view.dart';

class OnBoardingProvider
    extends ScreenProvider<OnBoardingState, OnBoardingView> {
  const OnBoardingProvider() : super();

  @override
  OnBoardingView build(BuildContext context, OnBoardingState state) =>
      OnBoardingView(
        onPressedYes: () => Navigator.pushAndRemoveUntil(
            context,
            NoAnimationMaterialPageRoute(
                builder: (_) => RequestLocationProvider()),
            (_) => false),
        onPressedNo: () => Navigator.pushAndRemoveUntil(
            context,
            NoAnimationMaterialPageRoute(builder: (_) => ApologyProvider()),
            (_) => false),
      );

  @override
  OnBoardingState buildState() => OnBoardingState();
}
