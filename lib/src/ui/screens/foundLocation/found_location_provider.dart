import 'package:flutter/material.dart';

import '../../../models/models.dart';
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
          MaterialPageRoute(
            builder: (_) => GymSearchProvider(),
          ),
        ),
        onPressedYes: () => Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => ExploreTutorialProvider(),
          ),
          (_) => false,
        ),
        address: gym.address,
      );

  @override
  FoundLocationState buildState() => FoundLocationState();
}
