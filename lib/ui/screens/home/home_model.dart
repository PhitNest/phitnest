import 'dart:async';

import 'package:flutter/material.dart';

import '../screens.dart';
import 'chatHome/chatCard/chat_card.dart';

/// This is the view model for the home view.
class HomeModel extends AuthenticatedModel {
  final PageController pageController = PageController();

  StreamSubscription<List<ChatCard>>? conversationListener;
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
