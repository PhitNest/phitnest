import 'package:flutter/material.dart';

import '../../../entities/entities.dart';
import '../provider.dart';
import 'match_state.dart';
import 'match_view.dart';

class MatchProvider extends ScreenProvider<MatchState, MatchView> {
  final ExploreUserEntity user;

  const MatchProvider(this.user) : super();

  @override
  MatchView build(BuildContext context, MatchState state) => MatchView(
        fullName: user.fullName,
        onPressedSayHello: () {},
        onPressedMeetMore: () => Navigator.of(context).pop(),
        onPressedLogo: () => Navigator.of(context).pop(),
      );

  @override
  MatchState buildState() => MatchState();
}
