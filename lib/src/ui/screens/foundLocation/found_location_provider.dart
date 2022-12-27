import 'package:flutter/material.dart';

import '../../../entities/entities.dart';
import '../../../repositories/repositories.dart';
import '../../widgets/widgets.dart';
import '../screen_provider.dart';
import '../screens.dart';
import 'found_location_state.dart';
import 'found_location_view.dart';

class FoundLocationProvider
    extends ScreenProvider<FoundLocationCubit, FoundLocationState> {
  final GymEntity gym;
  final LocationEntity location;
  final void Function(BuildContext context, GymEntity gym) onFoundNearestGym;

  const FoundLocationProvider({
    required this.gym,
    required this.location,
    required this.onFoundNearestGym,
  }) : super();

  @override
  FoundLocationView builder(
    BuildContext context,
    FoundLocationCubit cubit,
    FoundLocationState state,
  ) =>
      FoundLocationView(
        onPressedNo: () => Navigator.push(
          context,
          NoAnimationMaterialPageRoute(
            builder: (_) => GymSearchProvider(
              currentlySelectedGym: gym,
              userLocation: location,
              onFoundNearestGym: onFoundNearestGym,
            ),
          ),
        ),
        onPressedYes: () => onFoundNearestGym(context, gym),
        address: gym.address,
      );

  @override
  FoundLocationCubit buildCubit() => FoundLocationCubit();
}
