import 'package:flutter/material.dart';

import '../screen.dart';
import 'found_location_state.dart';
import 'found_location_view.dart';

class FoundLocationScreen
    extends Screen<FoundLocationState, FoundLocationView> {
  @override
  FoundLocationView build(BuildContext context, FoundLocationState state) =>
      FoundLocationView();

  @override
  FoundLocationState buildState() => FoundLocationState();
}
