import 'dart:async';

import 'package:geolocator/geolocator.dart';

import '../state.dart';

class RequestLocationState extends ScreenState {
  StreamSubscription<ServiceStatus>? serviceStatusListener;
}
