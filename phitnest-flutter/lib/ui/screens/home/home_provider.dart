import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

import '../../../apis/apis.dart';
import '../screens.dart';
import 'home_model.dart';
import 'home_view.dart';
import 'views/views.dart';

class HomeProvider extends AuthenticatedProvider<HomeModel, HomeView> {
  const HomeProvider({Key? key}) : super(key: key);

  /// If this returns true, the loading widget is dropped. If it returns false,
  /// the loading widget stays until we navigate away from the screen.
  /// If updating location, updating ip, and updating activity status all
  /// succeed, drop the loading screen. Otherwise
  @override
  init(BuildContext context, HomeModel model) async {
    if (!await super.init(context, model)) {
      return false;
    }
    StreamApi.instance.refreshWebSocket();

    model.user = await DatabaseApi.instance.getUserInfo();

    model.messageCards = (await DatabaseApi.instance.getRecentConversations())
        .map((entry) => ChatCard(
            message: entry.value.message,
            read: false,
            online: true,
            name: entry.key.name,
            onDismissConfirm: (direction) {},
            onTap: () =>
                Navigator.pushNamed(context, '/chat', arguments: entry.key)))
        .toList();

    if ([PermissionStatus.grantedLimited, PermissionStatus.granted]
        .contains(await Location.instance.requestPermission())) {
      model.userLocationListener = Location.instance.onLocationChanged
          .map((location) => LatLng(
              location.latitude ?? 51.509364, location.longitude ?? -0.128928))
          .listen((latlong) {
        model.userLocation = latlong;
      });
    }
    return true;
  }

  @override
  HomeView build(BuildContext context, HomeModel model) => HomeView(
        pageController: model.pageController,
        user: model.user,
        chatCards: model.messageCards,
        userLocation: model.userLocation,
        mapController: model.mapController,
        onClickEditProfileButton: () =>
            Navigator.pushNamed(context, '/editProfile'),
      );

  @override
  HomeModel createModel() => HomeModel();
}
