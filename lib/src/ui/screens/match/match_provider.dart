import 'package:flutter/material.dart';

import '../provider.dart';
import 'match_state.dart';
import 'match_view.dart';

class MatchProvider extends ScreenProvider<MatchState, MatchView> {
  @override
  MatchView build(BuildContext context, MatchState state) => MatchView(
        onPressedSayHello: () {},
        onPressedMeetMore: () {},
      );

  @override
  MatchState buildState() => MatchState();
}
