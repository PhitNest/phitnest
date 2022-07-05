import 'package:flutter/material.dart';

import '../../../models/models.dart';
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

    buildChatCards(model);
    return true;
  }

  @override
  ChatHomeView build(BuildContext context, ChatHomeModel model) => ChatHomeView(
        cards: model.chatCards,
      );

  void buildChatCards(ChatHomeModel model) {
    model.userStream?.cancel();
    model.userStream = databaseService.getAllUsers().listen((userInfo) async {
      if (userInfo != null) {
        ChatMessage? messageFrom =
            await chatService.getRecentChatMessagesFrom(userInfo.userId).first;
        ChatCard? from = messageFrom != null
            ? ChatCard(userInfo: userInfo, message: messageFrom)
            : null;

        ChatMessage? messageTo =
            await chatService.getRecentChatMessagesTo(userInfo.userId).first;
        ChatCard? to = messageTo != null
            ? ChatCard(userInfo: userInfo, message: messageTo)
            : null;

        if (from != null) {
          if (to != null) {
            model.addCard(from < to ? from : to);
            return;
          }

          model.addCard(from);
        }
      }
    });
  }

  @override
  ChatHomeModel createModel() => ChatHomeModel();
}
