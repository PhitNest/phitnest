import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import '../../../repositories/repositories.dart';
import '../screens.dart';
import '../provider.dart';
import 'gymCard/gym_card.dart';
import 'gym_search_state.dart';
import 'gym_search_view.dart';

class GymSearchProvider extends ScreenProvider<GymSearchState, GymSearchView> {
  const GymSearchProvider() : super();

  @override
  init(BuildContext context, GymSearchState state) =>
      repositories<LocationRepository>().getLocation().then((response) =>
          response.fold(
              (location) => repositories<LocationRepository>()
                      .getNearestGyms(location)
                      .then((gyms) {
                    state.gymsAndDistances = gyms
                        .map((gym) =>
                            Tuple2(gym, gym.location.distanceTo(location)))
                        .toList();
                    state.currentlySelectedGym = gyms[0];
                  }),
              (error) => state.errorMessage = error));

  @override
  GymSearchView build(BuildContext context, GymSearchState state) =>
      GymSearchView(
          searchController: state.searchController,
          errorMessage: state.errorMessage ?? '',
          onEditSearch: () => state.rebuildView(),
          onPressedConfirm: () {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (_) =>
                        FoundLocationProvider(gym: state.currentlySelectedGym)),
                (_) => false);
          },
          cards: state.gymsAndDistances
              .map((gymAndDistance) => state.searchController.text.length ==
                          0 ||
                      gymAndDistance.head.address.contains(
                          state.searchController.text.toLowerCase()) ||
                      gymAndDistance.head.name
                          .toLowerCase()
                          .contains(state.searchController.text.toLowerCase())
                  ? GymCard(
                      onPressed: () =>
                          state.currentlySelectedGym = gymAndDistance.head,
                      gym: gymAndDistance.head,
                      distance: gymAndDistance.tail,
                      selected:
                          gymAndDistance.head == state.currentlySelectedGym,
                    )
                  : null)
              .where((val) => val != null)
              .cast<GymCard>()
              .toList());

  @override
  dispose(BuildContext context, GymSearchState state) {}

  @override
  GymSearchState buildState() => GymSearchState();
}