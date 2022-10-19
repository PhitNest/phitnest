import 'package:flutter/material.dart';

import '../../../repositories/repositories.dart';
import '../screens.dart';
import '../provider.dart';
import 'on_boarding_state.dart';
import 'on_boarding_view.dart';

class OnBoardingProvider
    extends ScreenProvider<OnBoardingState, OnBoardingView> {
  const OnBoardingProvider() : super();

  @override
  Future init(BuildContext context, OnBoardingState state) =>
      repositories<EnvironmentRepository>().loadEnvironmentVariables();

  @override
  OnBoardingView build(BuildContext context, OnBoardingState state) =>
      OnBoardingView(
        onPressedYes: () => Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => RequestLocationProvider()),
            (_) => false),
        onPressedNo: () => Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (_) => ApologyProvider()), (_) => false),
      );

  @override
  OnBoardingState buildState() => OnBoardingState();
}
