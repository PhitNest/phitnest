import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:device/device.dart';
import 'package:phitnest/services/services.dart';

import '../../../models/models.dart';
import '../screens.dart';
import 'home_model.dart';
import 'home_view.dart';

class HomeProvider extends AuthenticatedProvider<HomeModel, HomeView> {
  HomeProvider({Key? key}) : super(key: key);

  /// If this returns true, the loading widget is dropped. If it returns false,
  /// the loading widget stays until we navigate away from the screen.
  /// If updating location, updating ip, and updating activity status all
  /// succeed, drop the loading screen. Otherwise
  @override
  init(BuildContext context, HomeModel model) async =>
      await Future.value(await super.init(context, model) &&
              await updateLocation() &&
              await updateIP() &&
              await updateActivity())
          .then((success) async {
        if (!success) {
          await authService.signOut("You've been signed out");
          Navigator.pushNamed(context, '/auth');
          return false;
        }
        authService.userModel!.notificationsEnabled =
            await chatService.requestNotificationPermissions();
        return await databaseService
                .updateFullUserModel(authService.userModel!) ==
            null;
      });

  @override
  HomeView build(BuildContext context, HomeModel model) => const HomeView();

  Future<bool> updateActivity() async {
    UserModel? user = authService.userModel;

    if (user != null) {
      user.online = true;
      user.lastOnlineTimestamp = DateTime.now().microsecondsSinceEpoch;
      return await databaseService.updateFullUserModel(user) == null;
    }
    return false;
  }

  Future<bool> updateLocation() async {
    UserModel? user = authService.userModel;

    if (user != null) {
      Position? position = await getCurrentLocation();
      if (position != null) {
        user.recentLocation = Location(
            latitude: position.latitude, longitude: position.longitude);

        return await databaseService.updateFullUserModel(user) == null;
      }

      return true;
    }
    return false;
  }

  Future<bool> updateIP() async {
    UserModel? user = authService.userModel;

    if (user != null) {
      user.recentIp = await userIP;
      return await databaseService.updateFullUserModel(user) == null;
    }
    return false;
  }

  @override
  HomeModel createModel() => HomeModel();
}
