import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong2/latlong.dart';

import '../../../models/models.dart';
import '../screen_view.dart';
import 'views/views.dart';

/// This is the view shown when users have been authenticated.
class HomeView extends ScreenView {
  final PageController pageController;
  final AuthenticatedUser user;
  final Function() onClickEditProfileButton;
  final List<ChatCard> chatCards;
  final LatLng? userLocation;
  final MapController? mapController;
  const HomeView(
      {Key? key,
      required this.pageController,
      required this.user,
      required this.onClickEditProfileButton,
      required this.userLocation,
      required this.mapController,
      required this.chatCards})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        body: PageView(
          controller: pageController,
          // Swipe right to see each individual children
          children: [
            ProfileView(
              firstName: user.firstName,
              lastName: user.lastName,
              bio: user.bio,
              onClickEditButton: onClickEditProfileButton,
            ),
            HeatmapView(
              mapController: mapController,
              userPosition: userLocation,
            ),
            ChatHomeView(
              cards: chatCards,
            ),
          ],
        ),
      );
}
