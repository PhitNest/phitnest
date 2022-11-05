import 'package:flutter/material.dart';

import '../../../models/models.dart';
import '../../../repositories/repositories.dart';
import '../../common/widgets.dart';
import '../provider.dart';
import '../screens.dart';
import 'found_location_state.dart';
import 'found_location_view.dart';

class FoundLocationProvider
    extends ScreenProvider<FoundLocationState, FoundLocationView> {
  final Gym gym;

  const FoundLocationProvider({required this.gym}) : super();

  @override
  FoundLocationView build(BuildContext context, FoundLocationState state) =>
      FoundLocationView(
        onPressedNo: () => Navigator.push(
          context,
          NoAnimationMaterialPageRoute(
            builder: (_) => GymSearchProvider(),
          ),
        ),
        onPressedYes: () {
          repositories<GymRepository>().currentlySelectedGym = gym;
          Navigator.pushAndRemoveUntil(
            context,
            NoAnimationMaterialPageRoute(
              builder: (_) => ExploreTutorialProvider(),
            ),
            (_) => false,
          );
        },
        address: gym.address,
      );

  @override
  FoundLocationState buildState() => FoundLocationState();
}
