import 'dart:async';

import 'package:flutter/material.dart';

import '../../widgets/widgets.dart';
import '../provider.dart';
import '../screens.dart';
import 'explore_state.dart';
import 'explore_view.dart';

class ExploreProvider extends ScreenProvider<ExploreState, ExploreView> {
  onTapDownLogo(BuildContext context, ExploreState state) {
    state.holding = true;
    state.countdown = 3;
    state.counter = new Timer.periodic(Duration(seconds: 1), (timer) {
      if (state.countdown == 1) {
        Navigator.pushAndRemoveUntil(
            context,
            NoAnimationMaterialPageRoute(builder: (context) => MatchProvider()),
            (_) => false);
      } else {
        state.countdown = state.countdown - 1;
      }
    });
  }

  onTapUpLogo(BuildContext context, ExploreState state) {
    state.holding = false;
    state.counter?.cancel();
  }

  @override
  ExploreView build(BuildContext context, ExploreState state) => ExploreView(
        holding: state.holding,
        countdown: state.countdown,
        onLogoTap: (context) => onTapDownLogo(context, state),
        onLogoRelease: (context) => onTapUpLogo(context, state),
      );

  @override
  ExploreState buildState() => ExploreState();
}
