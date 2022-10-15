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
        navIndex: state.navIndex,
        onLongPressLogo: () => state.setScreenIndex = 1,
        screenIndex: state.screenIndex,
      );

  @override
  ExploreTutorialState buildState() => ExploreTutorialState();
}
