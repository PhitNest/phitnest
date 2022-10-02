import 'package:flutter/material.dart';

import '../../../models/models.dart';
import '../screens.dart';
import '../provider.dart';
import 'found_location_state.dart';
import 'found_location_view.dart';

class FoundLocationProvider
    extends Provider<FoundLocationState, FoundLocationView> {
  final Gym gym;

  const FoundLocationProvider({required this.gym}) : super();

  @override
  FoundLocationView build(BuildContext context, FoundLocationState state) =>
      FoundLocationView(
        onPressedNo: () => Navigator.push(
            context, MaterialPageRoute(builder: (_) => GymSearchProvider())),
        address: gym.address,
      );

  @override
  FoundLocationState buildState() => FoundLocationState();
}
