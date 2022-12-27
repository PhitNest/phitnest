import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import '../../../entities/entities.dart';
import '../../../use-cases/use_cases.dart';
import '../../widgets/widgets.dart';
import '../screen_provider.dart';
import '../screens.dart';
import 'gym_search_state.dart';
import 'gym_search_view.dart';

class GymSearchProvider extends ScreenProvider<GymSearchCubit, GymSearchState> {
  final searchController = TextEditingController();
  final GymEntity currentlySelectedGym;
  final LocationEntity userLocation;
  final void Function(BuildContext context, GymEntity gym) onFoundNearestGym;
  final searchBoxKey = GlobalKey();

  GymSearchProvider({
    required this.currentlySelectedGym,
    required this.userLocation,
    required this.onFoundNearestGym,
  }) : super();

  @override
  Future<void> listener(
    BuildContext context,
    GymSearchCubit cubit,
    GymSearchState state,
  ) async {
    if (state is LoadingState) {
      getNearestGymsUseCase
          .get(location: userLocation, maxDistance: 30000)
          .then(
            (either) => either.fold(
              (gyms) => cubit.transitionToLoaded(
                gyms
                    .map(
                      (gym) => Tuple2(
                        gym,
                        gym.location.distanceTo(userLocation),
                      ),
                    )
                    .toList(),
                currentlySelectedGym,
                searchController.text.trim(),
              ),
              (failure) => cubit.transitionToError(failure.message),
            ),
          );
    }
  }

  @override
  Widget builder(
    BuildContext context,
    GymSearchCubit cubit,
    GymSearchState state,
  ) {
    if (state is LoadingState) {
      return const LoadingView();
    } else if (state is ErrorState) {
      return ErrorView(
        errorMessage: state.message,
        onPressedRetry: () => cubit.transitionToLoading(),
      );
    } else if (state is LoadedState) {
      return LoadedView(
        searchBoxKey: searchBoxKey,
        onPressedConfirm: () => Navigator.of(context)
          ..pop()
          ..pop()
          ..push(
            NoAnimationMaterialPageRoute(
              builder: (context) => FoundLocationProvider(
                gym: state.currentlySelectedGym,
                location: userLocation,
                onFoundNearestGym: onFoundNearestGym,
              ),
            ),
          ),
        gymsAndDistances: state.gymsAndDistances
            .where(
              (pair) =>
                  pair.value1.address.contains(
                    state.searchQuery.toLowerCase(),
                  ) ||
                  pair.value1.name.toLowerCase().contains(
                        state.searchQuery.toLowerCase(),
                      ),
            )
            .toList(),
        isSelected: (gym) => gym == state.currentlySelectedGym,
        onPressedGymCard: (gym) => cubit.setCurrentlySelectedGym(gym),
        onTapSearch: () => cubit.transitionToTyping(),
        searchController: searchController,
      );
    } else if (state is TypingState) {
      return TypingView(
        searchBoxKey: searchBoxKey,
        gymsAndDistances: state.gymsAndDistances
            .where(
              (pair) =>
                  pair.value1.address.contains(
                    state.searchQuery.toLowerCase(),
                  ) ||
                  pair.value1.name.toLowerCase().contains(
                        state.searchQuery.toLowerCase(),
                      ),
            )
            .toList(),
        isSelected: (gym) => gym == state.currentlySelectedGym,
        onPressedGymCard: (gym) => cubit.setCurrentlySelectedGym(gym),
        onSubmitSearch: () => cubit.transitionTypingToLoaded(),
        searchController: searchController,
        onEditSearch: () => cubit.setSearchQuery(
          searchController.text.trim(),
        ),
      );
    } else {
      throw Exception('Unknown state: $state');
    }
  }

  @override
  GymSearchCubit buildCubit() => GymSearchCubit();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
