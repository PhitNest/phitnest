import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ip/ip.dart';
import 'package:location/location.dart';

import '../../../models/models.dart';
import '../providers.dart';
import 'home_model.dart';
import 'home_view.dart';

class HomeProvider extends AuthenticatedProvider<HomeModel, HomeView> {
  HomeProvider({Key? key}) : super(key: key);

  late UserModel? user = authService.userModel;

  @override
  init(BuildContext context, HomeModel model) async =>
      await super.init(context, model) &&
      await updateLocation() &&
      await updateIP() &&
      await updateActivity();

  @override
  Widget buildLoading(BuildContext context, String? text) =>
      super.buildLoading(context, 'Account Details');

  @override
  HomeView build(BuildContext context) => const HomeView();

  Future<bool> updateActivity() async {
    if (user != null) {
      user!.online = true;
      return await databaseService.updateUserModel(user!) == null;
    }
    return false;
  }

  Future<bool> updateLocation() async {
    if (user != null) {
      {
        Position? position = await getCurrentLocation();

        if (position != null) {
          user!.location = UserLocation(
              latitude: position.latitude, longitude: position.longitude);
          await databaseService.updateUserModel(user!);
          return true;
        }
      }
    }
    return false;
  }

  Future<bool> updateIP() async {
    if (user != null) {
      user!.recentIP = await userIP;
      return await databaseService.updateUserModel(user!) == null;
    }
    return false;
  }
}
