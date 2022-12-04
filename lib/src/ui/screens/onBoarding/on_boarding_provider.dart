import 'package:flutter/material.dart';

import '../../../use-cases/use_cases.dart';
import '../../widgets/widgets.dart';
import '../screens.dart';
import '../provider.dart';
import 'on_boarding_state.dart';
import 'on_boarding_view.dart';

class OnBoardingProvider
    extends ScreenProvider<OnBoardingState, OnBoardingView> {
  const OnBoardingProvider() : super();

  @override
  init(BuildContext context, OnBoardingState state) async {
    if (skipOnBoardingUseCase.shouldSkip()) {
      await Future.delayed(
        Duration.zero,
        () => Navigator.of(context).pushReplacement(
          NoAnimationMaterialPageRoute(
            builder: (_) => LoginProvider(),
          ),
        ),
      );
    } else {
      skipOnBoardingUseCase.setShouldSkip();
    }
  }

  @override
  OnBoardingView build(BuildContext context, OnBoardingState state) =>
      OnBoardingView(
        onPressedYes: () => Navigator.pushAndRemoveUntil(
          context,
          NoAnimationMaterialPageRoute(
            builder: (_) => RequestLocationProvider(),
          ),
          (_) => false,
        ),
        onPressedNo: () => Navigator.pushAndRemoveUntil(
          context,
          NoAnimationMaterialPageRoute(
            builder: (_) => ApologyProvider(),
          ),
          (_) => false,
        ),
      );

  @override
  OnBoardingState buildState() => OnBoardingState();
}
