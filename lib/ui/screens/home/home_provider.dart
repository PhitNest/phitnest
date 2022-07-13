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
  const HomeProvider({Key? key}) : super(key: key);

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
      model.userListener = api<SocialApi>()
          .streamSignedInUser(model.currentUser.userId)
          .listen((user) => model.currentUser = user);
      model.conversationListener = streamChatCards(context, model)
          .listen((cards) => model.messageCards = cards);
      return true;
    }
    await api<AuthenticationApi>().signOut();
    Navigator.pushNamed(context, '/auth');
    return false;
  }

  Stream<List<ChatCard>> streamChatCards(
      BuildContext context, HomeModel model) {
    List<Conversation> conversationsSorted = [];
    Map<String, StreamSubscription<ChatMessage>>
        conversationIdToMessageListener = {};
    Map<String, ChatMessage> conversationIdToMessage = {};
    Map<String, StreamSubscription<UserPublicInfo?>>
        conversationIdToUserListener = {};
    Map<String, UserPublicInfo> conversationIdToUser = {};

    cancelListeners() {
      conversationIdToUserListener.forEach((key, value) => value.cancel());
      conversationIdToMessageListener.forEach((key, value) => value.cancel());
    }

    buildCards() => conversationsSorted
        .map((conversation) {
          UserPublicInfo? userInfo =
              conversationIdToUser[conversation.conversationId];
          ChatMessage? message =
              conversationIdToMessage[conversation.conversationId];
          if (userInfo == null || message == null) {
            return null;
          }
          return ChatCard(
            message: message.text,
            read: message.authorId == model.currentUser.userId || message.read,
            pictureUrl: userInfo.profilePictureUrl,
            onTap: () =>
                Navigator.pushNamed(context, '/chat', arguments: conversation),
            onDismissConfirm: (direction) async => await api<SocialApi>()
                .deleteConversation(conversation.conversationId),
            online: userInfo.online,
            name: userInfo.fullName,
          );
        })
        .where((element) => element != null)
        .map((card) => card!)
        .toList();

    StreamController<List<ChatCard>> streamController =
        StreamController<List<ChatCard>>(onCancel: cancelListeners);

    api<SocialApi>()
        .streamConversations(model.currentUser.userId)
        .listen((conversations) {
      conversationsSorted = [];
      cancelListeners();

      for (Conversation conversation in conversations) {
        if (!conversation.isGroup) {
          conversationsSorted.add(conversation);
          String otherUserId = conversation.participants
              .firstWhere((element) => element != model.currentUser.userId);
          conversationIdToUserListener[conversation.conversationId] =
              api<SocialApi>().streamUserInfo(otherUserId).listen((userInfo) {
            conversationIdToUser[conversation.conversationId] = userInfo!;
            streamController.sink.add(buildCards());
          });
          conversationIdToMessageListener[conversation.conversationId] =
              api<SocialApi>()
                  .streamMessages(conversation.conversationId, quantity: 1)
                  .map((messages) => messages.first)
                  .listen((message) {
            conversationIdToMessage[conversation.conversationId] = message;
            streamController.sink.add(buildCards());
          });
        }
      }
    });

    return streamController.stream;
  }

  @override
  HomeView build(BuildContext context, HomeModel model) => HomeView(
        pageController: model.pageController,
        cards: model.messageCards,
        user: model.currentUser,
      );

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
