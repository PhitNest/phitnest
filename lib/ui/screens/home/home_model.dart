import 'dart:async';

import 'package:flutter/material.dart';

import '../../../models/models.dart';
import '../screen_model.dart';
import 'chatHome/chatCard/chat_card.dart';

/// This is the view model for the home view.
class HomeModel extends ScreenModel {
  final PageController pageController = PageController();

  StreamSubscription<Map<UserPublicInfo, ChatMessage>>? conversationListener;

  List<ChatCard> _messageCards = [];

  List<ChatCard> get messageCards => _messageCards;

  set messageCards(List<ChatCard> messageCards) {
    _messageCards = messageCards;
    notifyListeners();
  }

  @override
  void dispose() {
    conversationListener?.cancel();
    super.dispose();
  }
}
