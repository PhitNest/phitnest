import 'dart:async';

import 'package:flutter/material.dart';

import '../../common/widgets.dart';
import '../provider.dart';
import 'explore_state.dart';
import 'explore_view.dart';

class ExploreProvider extends ScreenProvider<ExploreState, ExploreView> {
  @override
  onTapDownLogo(BuildContext context, ExploreState state) {
    state.holding = true;
    state.countdown = 3;
    state.counter = new Timer.periodic(Duration(seconds: 1), (timer) {
      if (state.countdown == 1) {
        Navigator.pushAndRemoveUntil(
            context,
            NoAnimationMaterialPageRoute(
                builder: (context) => ExploreProvider()),
            (_) => false);
      } else {
        state.countdown = state.countdown - 1;
      }
    });
  }

  @override
  onTapUpLogo(BuildContext context, ExploreState state) {
    state.holding = false;
    state.counter?.cancel();
  }

  @override
  ExploreView build(BuildContext context, ExploreState state) => ExploreView(
        holding: state.holding,
        countdown: state.countdown,
      );

  @override
  ExploreState buildState() => ExploreState();
}
