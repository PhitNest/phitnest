import 'dart:async';

import 'package:flutter/material.dart';

import '../../screen_model.dart';
import '../views/home_view.dart';

export 'chatHome/chat_home_model.dart';
export 'profile/profile_model.dart';

/// This is the view model for the home view.
class HomeModel extends ScreenModel {
  final PageController pageController = PageController();

  StreamSubscription<List<ChatCard>>? chatCardListener;

  List<ChatCard> _messageCards = [];
  List<ChatCard> get messageCards => _messageCards;

  set messageCards(List<ChatCard> messageCards) {
    _messageCards = messageCards;
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
