import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

import '../../screen_model.dart';
import '../views/home_view.dart';

export 'chatHome/chat_home_model.dart';
export 'profile/profile_model.dart';
export 'heatmap/heatmap_model.dart';

/// This is the view model for the home view.
class HomeModel extends ScreenModel {
  final PageController pageController = PageController();
  late final List<ChatCard> initialMessageCards;
  late final Stream<LatLng?> userLocationStream;
}
