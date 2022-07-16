import 'dart:async';

import 'package:flutter/material.dart';

import '../../../screens.dart';
import '../../models/home_model.dart';
import '../../views/home_view.dart';

class ChatHomeProvider extends ScreenProvider<ChatHomeModel, ChatHomeView> {
  final List<ChatCard> messageCards;

  const ChatHomeProvider({Key? key, required this.messageCards})
      : super(key: key);

  @override
  ChatHomeView build(BuildContext context, ChatHomeModel model) =>
      ChatHomeView(cards: messageCards);

  @override
  ChatHomeModel createModel() => ChatHomeModel();
}
