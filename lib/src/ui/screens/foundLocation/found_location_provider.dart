import 'package:flutter/material.dart';

import '../../../entities/entities.dart';
import '../../../repositories/repositories.dart';
import '../../widgets/widgets.dart';
import '../provider.dart';
import '../screens.dart';
import 'found_location_state.dart';
import 'found_location_view.dart';

class FoundLocationProvider
    extends ScreenProvider<FoundLocationState, FoundLocationView> {
  final GymEntity gym;
  final LocationEntity userLocation;
  final void Function(
    BuildContext context,
    LocationEntity location,
    GymEntity gym,
  ) onFoundUsersGym;

  const FoundLocationProvider({
    required this.gym,
    required this.userLocation,
    required this.onFoundUsersGym,
  }) : super();

  @override
  FoundLocationView build(BuildContext context, FoundLocationState state) =>
      FoundLocationView(
        onPressedBack: () => Navigator.of(context)
          ..pop()
          ..pop(),
        onPressedNo: () => Navigator.push(
          context,
          NoAnimationMaterialPageRoute(
            builder: (_) => GymSearchProvider(
              gym: gym,
              userLocation: userLocation,
              onFoundUsersGym: onFoundUsersGym,
            ),
          ),
        ),
        onPressedYes: () {
          memoryCacheRepo.myGym = gym;
          onFoundUsersGym(context, userLocation, gym);
        },
        address: gym.address,
      );

  @override
  FoundLocationState buildState() => FoundLocationState();
}
