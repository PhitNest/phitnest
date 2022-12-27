import 'package:flutter/material.dart';
import 'package:phitnest_mobile/src/repositories/repositories.dart';

import '../../../use-cases/use_cases.dart';
import '../../widgets/widgets.dart';
import '../screen_provider.dart';
import '../screens.dart';
import 'on_boarding_state.dart';
import 'on_boarding_view.dart';

class OnBoardingProvider
    extends ScreenProvider<OnBoardingCubit, OnBoardingState> {
  const OnBoardingProvider() : super();

  @override
  Future<void> listener(
    BuildContext context,
    OnBoardingCubit cubit,
    OnBoardingState state,
  ) async {
    if (state is InitialState) {
      skipOnBoardingUseCase.shouldSkip().then(
            (skip) => skip
                ? Navigator.pushAndRemoveUntil(
                    context,
                    NoAnimationMaterialPageRoute(
                      builder: (_) => LoginProvider(),
                    ),
                    (_) => false,
                  )
                : skipOnBoardingUseCase
                    .setShouldSkip()
                    .then((_) => cubit.transitionToLoaded()),
          );
    }
  }

  @override
  Widget builder(
    BuildContext context,
    OnBoardingCubit cubit,
    OnBoardingState state,
  ) {
    if (state is LoadedState) {
      return OnBoardingView(
        onPressedYes: () => Navigator.pushAndRemoveUntil(
          context,
          NoAnimationMaterialPageRoute(
            builder: (_) => RequestLocationProvider(
              onFoundNearestGym: (context, gym) async {
                memoryCacheRepo.myGym = gym;
                Navigator.pushAndRemoveUntil(
                  context,
                  NoAnimationMaterialPageRoute(
                    builder: (context) => ExploreTutorialProvider(),
                  ),
                  (_) => false,
                );
              },
            ),
          ),
          (_) => false,
        ),
      );
    } else if (state is InitialState) {
      return const InitialView();
    } else {
      throw Exception('Unknown state: $state');
    }
  }

  @override
  OnBoardingCubit buildCubit() => OnBoardingCubit();
}
