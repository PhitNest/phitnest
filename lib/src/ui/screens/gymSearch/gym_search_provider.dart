import 'package:flutter/material.dart';

import '../../widgets/widgets.dart';
import '../screens.dart';
import '../provider.dart';
import 'widgets/gym_card.dart';
import 'gym_search_state.dart';
import 'gym_search_view.dart';

class GymSearchProvider extends ScreenProvider<GymSearchState, GymSearchView> {
  const GymSearchProvider() : super();

  @override
  GymSearchView build(BuildContext context, GymSearchState state) =>
      GymSearchView(
        showConfirmButton: state.showConfirmButton,
        searchController: state.searchController,
        searchFocus: state.searchFocus,
        onTapSearch: () => state.showConfirmButton = false,
        errorMessage: state.errorMessage ?? '',
        onEditSearch: state.editSearch,
        onPressedConfirm: () {
          Navigator.of(context).pushAndRemoveUntil(
              NoAnimationMaterialPageRoute(
                builder: (_) =>
                    FoundLocationProvider(gym: state.currentlySelectedGym),
              ),
              (_) => false);
        },
        cards: state.gymsAndDistances
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
            .toList(),
      );

  @override
  GymSearchState buildState() => GymSearchState();
}
