import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:device/device.dart';

import '../../../apis/api.dart';
import '../../../models/models.dart';
import '../screens.dart';
import 'chatHome/chatCard/chat_card.dart';
import 'home_model.dart';
import 'home_view.dart';

class HomeProvider extends AuthenticatedProvider<HomeModel, HomeView> {
  HomeProvider({Key? key}) : super(key: key);

  /// If this returns true, the loading widget is dropped. If it returns false,
  /// the loading widget stays until we navigate away from the screen.
  /// If updating location, updating ip, and updating activity status all
  /// succeed, drop the loading screen. Otherwise
  @override
  init(BuildContext context, HomeModel model) async {
    if (!(await super.init(context, model))) {
      return false;
    }

    if (await updateLocation(model.currentUser) &&
        await updateIP(model.currentUser) &&
        await updateActivity(model.currentUser)) {
      model.conversationListener = api<SocialApi>()
          .streamConversations()
          .map((conversations) => conversations
              .map((conversation) => ChatCard(
                    conversation: conversation,
                  ))
              .toList())
          .listen((cards) => model.messageCards = cards);
      return true;
    }
    await api<AuthenticationApi>().signOut();
    Navigator.pushNamed(context, '/auth');
    return false;
  }

  @override
  HomeView build(BuildContext context, HomeModel model) =>
      HomeView(pageController: model.pageController, cards: model.messageCards);

  Future<bool> updateActivity(AuthenticatedUser user) async {
    user.online = true;
    user.lastOnlineTimestamp = DateTime.now();
    return await api<SocialApi>().updateUserModel(user) == null;
  }

  Future<bool> updateLocation(AuthenticatedUser user) async {
    Position? position = await getCurrentLocation();
    if (position != null) {
      user.recentLocation =
          Location(latitude: position.latitude, longitude: position.longitude);

      return await api<SocialApi>().updateUserModel(user) == null;
    }

    return true;
  }

  Future<bool> updateIP(AuthenticatedUser user) async {
    user.recentIp = await userIP;
    return await api<SocialApi>().updateUserModel(user) == null;
  }

  @override
  HomeModel createModel() => HomeModel();
}
