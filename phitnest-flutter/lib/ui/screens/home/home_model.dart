import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../../models/models.dart';
import '../screen_model.dart';
import 'views/views.dart';

/// This is the view model for the home view.
class HomeModel extends ScreenModel {
  final PageController pageController = PageController();
  final MapController mapController = MapController();

  late AuthenticatedUser _user;

  AuthenticatedUser get user => _user;

  set user(AuthenticatedUser user) {
    _user = user;
    notifyListeners();
  }

  List<ChatCard> _messageCards = [];

  List<ChatCard> get messageCards => _messageCards;

  set messageCards(List<ChatCard> messageCards) {
    _messageCards = messageCards;
    notifyListeners();
  }

  StreamSubscription<LatLng?>? userLocationListener;
  LatLng? _userLocation;

  LatLng? get userLocation => _userLocation;

  set userLocation(LatLng? userLocation) {
    _userLocation = userLocation;
    notifyListeners();
  }

  @override
  void dispose() {
    userLocationListener?.cancel();
    super.dispose();
  }
}
