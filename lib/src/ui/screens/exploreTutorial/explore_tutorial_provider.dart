import 'dart:async';

import 'package:flutter/material.dart';

import '../../widgets/widgets.dart';
import '../provider.dart';
import '../screens.dart';
import 'explore_tutorial_state.dart';
import 'explore_tutorial_view.dart';

class ExploreTutorialProvider
    extends ScreenProvider<ExploreTutorialState, ExploreTutorialView> {
  @override
  ExploreTutorialView build(BuildContext context, ExploreTutorialState state) =>
      ExploreTutorialView(
        countdown: state.countdown,
        holding: state.holding,
        onLogoTap: () {
          state.holding = true;
          state.countdown = 3;
          state.counter = new Timer.periodic(
            Duration(seconds: 1),
            (timer) {
              if (state.countdown == 1) {
                Navigator.pushAndRemoveUntil(
                  context,
                  NoAnimationMaterialPageRoute(
                    builder: (context) => const ExploreProvider(),
                  ),
                  (_) => false,
                );
              } else {
                state.countdown = state.countdown - 1;
              }
            },
          );
        },
        onLogoRelease: () {
          state.holding = false;
          state.counter?.cancel();
        },
      );

  @override
  ExploreTutorialState buildState() => ExploreTutorialState();
}
