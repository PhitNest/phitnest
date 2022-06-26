import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../../services/services.dart';
import '../screen_view.dart';
import '../screens.dart';
import 'chat_listener_model.dart';

abstract class ChatListenerProvider<T extends ChatListenerModel,
    K extends ScreenView> extends AuthenticatedProvider<T, K> {
  ChatListenerProvider({Key? key}) : super(key: key);

  @override
  Future<bool> init(BuildContext context, T model) async {
    if (!await super.init(context, model)) {
      return false;
    }

    model.chatStream =
        chatService.openForegroundMessageStream(receiveMessageCallback);
    return true;
  }

  receiveMessageCallback(dynamic message);
}
