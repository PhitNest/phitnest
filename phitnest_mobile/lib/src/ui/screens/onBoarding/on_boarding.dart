import 'package:flutter/material.dart';

import '../../../constants/routes.dart';
import '../../../repositories/repositories.dart';
import '../screen.dart';
import 'on_boarding_state.dart';
import 'on_boarding_view.dart';

class OnBoardingScreen extends Screen<OnBoardingState, OnBoardingView> {
  const OnBoardingScreen() : super();

  static const Duration splashDuration = Duration(seconds: 1);
  static const Duration fadeoutDuration = Duration(milliseconds: 500);

  @override
  Future<void> init(BuildContext context, OnBoardingState state) =>
      repositories<DeviceCacheRepository>()
          .completedOnBoarding
          .then((completed) {
        if (completed) {}
      });

  @override
  OnBoardingView build(BuildContext context, OnBoardingState state) =>
      OnBoardingView(
        onPressedYes: () => Navigator.pushNamedAndRemoveUntil(
            context, kRequestLocation, (_) => false),
        onPressedNo: () =>
            Navigator.pushNamedAndRemoveUntil(context, kApology, (_) => false),
      );

  @override
  OnBoardingState buildState() => OnBoardingState();
}
