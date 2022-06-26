import 'package:flutter/material.dart';

import '../../../services/services.dart';
import '../../common/widgets/widgets.dart';
import '../screens.dart';
import 'chat_home_model.dart';
import 'chat_home_view.dart';

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
        model.addCard(ChatCard(user: user));
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

  @override
  ChatHomeModel createModel() => ChatHomeModel();
}
