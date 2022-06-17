import 'package:flutter/material.dart';
import 'package:phitnest/ui/screens/chatHome/chatCard/chat_card.dart';
import 'package:phitnest/ui/screens/providers.dart';

import '../models.dart';
import '../views.dart';

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
