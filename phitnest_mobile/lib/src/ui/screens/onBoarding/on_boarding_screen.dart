import 'package:flutter/material.dart';

import '../../../repositories/repositories.dart';
import '../screen.dart';
import 'on_boarding_state.dart';
import 'on_boarding_view.dart';

class OnBoardingScreen extends Screen<OnBoardingState, OnBoardingView> {
  const OnBoardingScreen() : super();

  @override
  Future init(BuildContext context, OnBoardingState state) =>
      repositories<EnvironmentRepository>().loadEnvironmentVariables();

  @override
  OnBoardingView build(BuildContext context, OnBoardingState state) =>
      OnBoardingView(
        onPressedYes: () => Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => RequestLocationScreen()),
            (_) => false),
        onPressedNo: () => Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (_) => ApologyScreen()), (_) => false),
      );

  @override
  OnBoardingState buildState() => OnBoardingState();
}
