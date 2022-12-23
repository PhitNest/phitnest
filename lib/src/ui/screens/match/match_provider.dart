import 'package:flutter/material.dart';

import '../../../entities/entities.dart';
import '../screen_provider.dart';
import 'match_state.dart';
import 'match_view.dart';

class MatchProvider extends ScreenProvider<MatchCubit, MatchState> {
  final ExploreUserEntity friend;

  MatchProvider(this.friend) : super();

  @override
  MatchView builder(
    BuildContext context,
    MatchCubit cubit,
    MatchState state,
  ) =>
      MatchView(
        fullName: friend.fullName,
        onPressedSayHello: () => Navigator.of(context).pop(),
        onPressedMeetMore: () => Navigator.of(context).pop(),
        onPressedLogo: () => Navigator.of(context).pop(),
      );

  @override
  MatchCubit buildCubit() => MatchCubit();
}
