import 'package:flutter/material.dart';

import '../../../repositories/repositories.dart';
import '../screen.dart';
import 'gym_search_state.dart';
import 'gym_search_view.dart';

class GymSearchScreen extends Screen<GymSearchState, GymSearchView> {
  const GymSearchScreen() : super();

  @override
  init(BuildContext context, GymSearchState state) =>
      repositories<LocationRepository>().getLocation().then((response) =>
          response.fold(
              (location) => repositories<LocationRepository>()
                  .getNearestGyms(location)
                  .then((gyms) => state.gyms = gyms),
              (error) => state.errorMessage = error));

  @override
  GymSearchView build(BuildContext context, GymSearchState state) =>
      GymSearchView(
        errorMessage: state.errorMessage ?? '',
        onPressedConfirm: () => {},
      );

  @override
  GymSearchState buildState() => GymSearchState();
}
