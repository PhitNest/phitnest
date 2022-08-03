import 'dart:async';

import 'package:latlong2/latlong.dart';

import '../../../screen_model.dart';

class HeatmapModel extends ScreenModel {
  StreamSubscription<LatLng?>? userLocationListener;

  @override
  void dispose() {
    userLocationListener?.cancel();
    super.dispose();
  }
}
