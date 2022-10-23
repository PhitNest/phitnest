import 'package:flutter/material.dart';

import '../provider.dart';
import 'explore_state.dart';
import 'explore_view.dart';

class ExploreProvider extends ScreenProvider<ExploreState, ExploreView> {
  @override
  ExploreView build(BuildContext context, ExploreState state) => ExploreView();

  @override
  ExploreState buildState() => ExploreState();
}
