import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import '../../../use-cases/use_cases.dart';
import '../../widgets/widgets.dart';
import '../provider.dart';
import '../screens.dart';
import 'explore_state.dart';
import 'explore_view.dart';
import 'widgets/widgets.dart';

class ExploreProvider extends ScreenProvider<ExploreState, ExploreView> {
  @override
  Future<void> init(BuildContext context, ExploreState state) async {
    state.errorMessage = null;
    state.exploreUsers = null;
    exploreUseCase.exploreUsers().then(
          (either) => either.fold(
            (users) => state.exploreUsers = users,
            (failure) {
              state.errorMessage = failure.message;
            },
          ),
        );
  }

  const ExploreProvider() : super();

  @override
  ExploreView build(BuildContext context, ExploreState state) => ExploreView(
        holding: state.holding,
        onChangePage: (pageIndex) =>
            state.currentUserIndex = pageIndex % state.exploreUsers!.length,
        countdown: state.countdown,
        errorMessage: state.errorMessage,
        cards: state.exploreUsers != null
            ? state.exploreUsers!
                .asMap()
                .entries
                .map(
                  (entry) => ExploreCard(
                    fullName: entry.value.fullName,
                    countdown: state.holding ? state.countdown : null,
                  ),
                )
                .toList()
            : null,
        onLogoTap: state.exploreUsers != null
            ? (state.exploreUsers!.length > 0
                ? () {
                    state.holding = true;
                    state.countdown = 3;
                    state.counter = new Timer.periodic(
                      Duration(seconds: 1),
                      (timer) async {
                        if (state.countdown == 1) {
                          Random random = new Random();
                          if (random.nextBool()) {
                            Navigator.push(
                              context,
                              NoAnimationMaterialPageRoute(
                                builder: (context) => MatchProvider(state
                                    .exploreUsers![state.currentUserIndex]),
                              ),
                            );
                            await Future.delayed(
                              const Duration(milliseconds: 100),
                            );
                          }
                          state.removeExploreUser(state.currentUserIndex);
                          if (state.currentUserIndex ==
                              state.exploreUsers!.length) {
                            state.currentUserIndex = state.currentUserIndex - 1;
                          }
                          state.holding = false;
                          state.counter?.cancel();
                        } else {
                          state.countdown = state.countdown - 1;
                        }
                      },
                    );
                  }
                : () {})
            : () {},
        onLogoRelease: state.exploreUsers != null
            ? (state.exploreUsers!.length > 0
                ? () {
                    state.holding = false;
                    state.counter?.cancel();
                  }
                : () {})
            : () {},
      );

  @override
  ExploreState buildState() => ExploreState();
}
