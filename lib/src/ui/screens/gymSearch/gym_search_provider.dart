import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import '../../../entities/entities.dart';
import '../../../use-cases/use_cases.dart';
import '../../widgets/widgets.dart';
import '../screens.dart';
import '../provider.dart';
import 'widgets/gym_card.dart';
import 'gym_search_state.dart';
import 'gym_search_view.dart';

class GymSearchProvider extends ScreenProvider<GymSearchState, GymSearchView> {
  final GymEntity gym;
  final LocationEntity userLocation;
  final void Function(
    BuildContext context,
    LocationEntity location,
    GymEntity gym,
  ) onFoundUsersGym;

  @override
  Future<void> init(BuildContext context, GymSearchState state) async {
    state.currentlySelectedGym = gym;
    state.errorMessage = null;
    state.gymsAndDistances = null;
    getNearestGymsUseCase
        .get(
          location: userLocation,
          maxDistance: 30000,
        )
        .then(
          (either) => either.fold(
            (gyms) => state.gymsAndDistances = gyms
                .map(
                  (gym) => Tuple2(
                    gym,
                    userLocation.distanceTo(gym.location),
                  ),
                )
                .toList(),
            (failure) => onFailure(failure, state),
          ),
        );
  }

  void onFailure(Failure failure, GymSearchState state) {
    state.errorMessage = failure.message;
  }

  const GymSearchProvider({
    required this.gym,
    required this.userLocation,
    required this.onFoundUsersGym,
  }) : super();

  @override
  GymSearchView build(BuildContext context, GymSearchState state) =>
      GymSearchView(
        showConfirmButton: state.showConfirmButton,
        searchController: state.searchController,
        searchFocus: state.searchFocus,
        onPressRetry: () => init(context, state),
        onTapSearch: () => state.showConfirmButton = false,
        errorMessage: state.errorMessage,
        onEditSearch: state.editSearch,
        onPressedConfirm: () {
          Navigator.of(context)
            ..pop()
            ..pop()
            ..push(
              NoAnimationMaterialPageRoute(
                builder: (_) => FoundLocationProvider(
                  gym: state.currentlySelectedGym,
                  userLocation: userLocation,
                  onFoundUsersGym: onFoundUsersGym,
                ),
              ),
            );
        },
        cards: state.gymsAndDistances != null
            ? state.gymsAndDistances!
                .map(
                  (gymAndDistance) => state.searchController.text.length == 0 ||
                          gymAndDistance.head.address.contains(
                            state.searchController.text.toLowerCase(),
                          ) ||
                          gymAndDistance.head.name.toLowerCase().contains(
                                state.searchController.text.toLowerCase(),
                              )
                      ? GymCard(
                          onPressed: () =>
                              state.currentlySelectedGym = gymAndDistance.head,
                          gym: gymAndDistance.head,
                          distance: gymAndDistance.tail,
                          selected:
                              gymAndDistance.head == state.currentlySelectedGym,
                        )
                      : null,
                )
                .where(
                  (val) => val != null,
                )
                .cast<GymCard>()
                .toList()
            : null,
      );

  @override
  GymSearchState buildState() => GymSearchState();
}
