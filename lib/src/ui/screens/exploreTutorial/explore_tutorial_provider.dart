import 'package:flutter/material.dart';

import '../provider.dart';
import 'explore_tutorial_state.dart';
import 'explore_tutorial_view.dart';

class ExploreTutorialProvider
    extends ScreenProvider<ExploreTutorialState, ExploreTutorialView> {
  ExploreTutorialProvider() : super();

  @override
  ExploreTutorialView build(BuildContext context, ExploreTutorialState state) =>
      ExploreTutorialView(
        onTapDownLogo: (details) {
          state.holding = true;
        },
        onTapUpLogo: (details) {
          state.holding = false;
        },
        countdown: state.countdown,
        holding: state.holding,
      );

  @override
  ExploreTutorialState buildState() => ExploreTutorialState();
}
