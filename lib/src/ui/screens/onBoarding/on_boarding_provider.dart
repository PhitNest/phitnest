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
    if (await skipOnBoardingUseCase.shouldSkip()) {
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
            builder: (_) => RequestLocationProvider(
              onFoundUsersGym: (context, location, gym) =>
                  Navigator.pushAndRemoveUntil(
                context,
                NoAnimationMaterialPageRoute(
                  builder: (context) => ExploreTutorialProvider(),
                ),
                (_) => false,
              ),
            ),
          ),
          (_) => false,
        ),
        onPressedNo: () => Navigator.push(
          context,
          NoAnimationMaterialPageRoute(
            builder: (_) => ApologyProvider(),
          ),
        ),
      );

  @override
  OnBoardingState buildState() => OnBoardingState();
}
