import 'dart:async';

import 'package:flutter/material.dart';

import '../../common/widgets.dart';
import '../provider.dart';
import '../screens.dart';
import 'explore_tutorial_state.dart';
import 'explore_tutorial_view.dart';

class ExploreTutorialProvider
    extends ScreenProvider<ExploreTutorialState, ExploreTutorialView> {
  @override
  onTapDownLogo(BuildContext context, ExploreTutorialState state) {
    state.holding = true;
    state.countdown = 3;
    state.counter = new Timer.periodic(Duration(seconds: 1), (timer) {
      state.countdown = state.countdown - 1;
      if (state.countdown == 0) {
        Navigator.pushAndRemoveUntil(
            context,
            NoAnimationMaterialPageRoute(
                builder: (context) => ExploreProvider()),
            (_) => false);
      }
    });
  }

  @override
  onTapUpLogo(BuildContext context, ExploreTutorialState state) {
    state.holding = false;
    state.counter?.cancel();
  }

  @override
  ExploreTutorialView build(BuildContext context, ExploreTutorialState state) =>
      ExploreTutorialView(
        countdown: state.countdown,
        holding: state.holding,
      );

  @override
  ExploreTutorialState buildState() => ExploreTutorialState();
}
