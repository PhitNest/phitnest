import 'package:flutter/material.dart';

import '../models.dart';
import '../providers.dart';
import '../views.dart';
import 'chatCard/chat_card.dart';

class ChatHomeProvider
    extends ChatListenerProvider<ChatHomeModel, ChatHomeView> {
  ChatHomeProvider({Key? key}) : super(key: key);

  @override
  Future<bool> init(BuildContext context, ChatHomeModel model) async {
    if (!await super.init(context, model)) {
      return false;
    }

    model.userStream = databaseService.getAllUsers().listen((user) {
      if (user != null) {
        model.addCard(ChatCard(user));
      }
    });

    return true;
  }

  @override
  ChatHomeView build(BuildContext context, ChatHomeModel model) => ChatHomeView(
        cards: model.chatCards,
      );

  @override
  receiveMessageCallback(message) {}
}
