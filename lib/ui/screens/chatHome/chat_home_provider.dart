import 'package:flutter/material.dart';

import '../../../services/services.dart';
import '../screens.dart';
import 'chatCard/chat_card.dart';
import 'chat_home_model.dart';
import 'chat_home_view.dart';

class ChatHomeProvider extends ScreenProvider<ChatHomeModel, ChatHomeView> {
  ChatHomeProvider({Key? key}) : super(key: key);

  @override
  Future<bool> init(BuildContext context, ChatHomeModel model) async {
    if (!await super.init(context, model)) {
      return false;
    }

    model.userStream = databaseService.getAllUsers().listen((userInfo) async {
      if (userInfo != null) {
        ChatCard from = ChatCard(
            userInfo: userInfo,
            displayedMessage: await chatService
                .getRecentChatMessagesFrom(userInfo.userId)
                .first);
        ChatCard to = ChatCard(
            userInfo: userInfo,
            displayedMessage: await chatService
                .getRecentChatMessagesTo(userInfo.userId)
                .first);
        model.addCard(from < to ? from : to);
      }
    });

    return true;
  }

  @override
  ChatHomeView build(BuildContext context, ChatHomeModel model) => ChatHomeView(
        cards: model.chatCards,
      );

  @override
  ChatHomeModel createModel() => ChatHomeModel();
}
