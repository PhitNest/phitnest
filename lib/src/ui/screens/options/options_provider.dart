import 'package:flutter/material.dart';

import '../../../repositories/repositories.dart';
import '../../../use-cases/use_cases.dart';
import '../../widgets/widgets.dart';
import '../screen_provider.dart';
import '../screens.dart';
import 'options_state.dart';
import 'options_view.dart';

class OptionsProvider extends ScreenProvider<OptionsCubit, OptionsState> {
  OptionsProvider() : super();

  @override
  Future<void> listener(
      BuildContext context, OptionsCubit cubit, OptionsState state) async {
    if (state is InitialState) {
      if (memoryCacheRepo.me == null) {
        await getUserUseCase.getUser();
      }
      if (memoryCacheRepo.me != null) {
        getGymUseCase.getGym().then(
              (either) => either.fold(
                (gym) {
                  memoryCacheRepo.myGym = gym;
                  cubit.transitionToLoaded();
                },
                (failure) => cubit.transitionToError(
                  failure.message,
                ),
              ),
            );
      } else {
        Navigator.pushAndRemoveUntil(
          context,
          NoAnimationMaterialPageRoute(
            builder: (context) => UnauthorizedProvider(),
          ),
          (_) => false,
        );
      }
    }
  }

  @override
  Widget builder(
    BuildContext context,
    OptionsCubit cubit,
    OptionsState state,
  ) {
    if (state is InitialState) {
      return const InitialView();
    } else if (state is LoadedState) {
      return LoadedView(
        user: memoryCacheRepo.me!,
        gym: memoryCacheRepo.myGym!,
      );
    } else if (state is ErrorState) {
      return ErrorView(
        errorMessage: state.message,
        onPressedRetry: () => cubit.transitionToInitial(),
      );
    } else {
      throw Exception('Unknown state: $state');
    }
  }

  @override
  OptionsCubit buildCubit() => OptionsCubit();
}
