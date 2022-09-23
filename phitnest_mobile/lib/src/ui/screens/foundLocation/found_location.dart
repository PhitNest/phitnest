import 'package:flutter/material.dart';

import '../../../models/models.dart';
import '../../../routes.dart';
import '../screen.dart';
import 'found_location_state.dart';
import 'found_location_view.dart';

class FoundLocationScreen
    extends Screen<FoundLocationState, FoundLocationView> {
  final Gym gym;

  const FoundLocationScreen({required this.gym}) : super();

  @override
  FoundLocationView build(BuildContext context, FoundLocationState state) =>
      FoundLocationView(
        onPressedNo: () => Navigator.pushNamed(context, kGymSearch),
        address: gym.address,
      );

  @override
  FoundLocationState buildState() => FoundLocationState();
}
