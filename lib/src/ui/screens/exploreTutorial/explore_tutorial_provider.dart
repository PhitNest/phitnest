import 'dart:async';

import 'package:flutter/material.dart';

import '../../widgets/widgets.dart';
import '../screen_provider.dart';
import '../screens.dart';
import 'explore_tutorial_state.dart';
import 'explore_tutorial_view.dart';

class ExploreTutorialProvider
    extends ScreenProvider<ExploreTutorialCubit, ExploreTutorialState> {
  final navbarKey = GlobalKey();

  @override
  Future<void> listener(
    BuildContext context,
    ExploreTutorialCubit cubit,
    ExploreTutorialState state,
  ) async {
    if (state is HoldingState) {
      if (state.countdown == 0) {
        Navigator.pushAndRemoveUntil(
          context,
          NoAnimationMaterialPageRoute(
            builder: (context) => ExploreProvider(),
          ),
          (_) => false,
        );
      }
    }
  }

  @override
  Widget builder(
    BuildContext context,
    ExploreTutorialCubit cubit,
    ExploreTutorialState state,
  ) {
    if (state is HoldingState) {
      return HoldingView(
        navbarKey: navbarKey,
        countdown: state.countdown,
        onLogoRelease: () => cubit.transitionToInitial(),
      );
    } else if (state is InitialState) {
      return InitialView(
        navbarKey: navbarKey,
        onPressLogo: () => cubit.transitionToHolding(),
      );
    } else {
      throw Exception('Unknown state: $state');
    }
  }

  @override
  ExploreTutorialCubit buildCubit() => ExploreTutorialCubit();
}
