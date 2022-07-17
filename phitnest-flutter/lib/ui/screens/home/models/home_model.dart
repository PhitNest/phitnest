import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../models/models.dart';
import '../../screens.dart';
import '../views/home_view.dart';

export 'chatHome/chat_home_model.dart';
export 'profile/profile_model.dart';

/// This is the view model for the home view.
class HomeModel extends AuthenticatedModel {
  final PageController pageController = PageController();

  StreamSubscription<AuthenticatedUser>? userListener;

  StreamSubscription<List<ChatCard>>? chatCardListener;
  List<ChatCard> _messageCards = [];

  List<ChatCard> get messageCards => _messageCards;

  set messageCards(List<ChatCard> messageCards) {
    _messageCards = messageCards;
    notifyListeners();
  }

  @override
  void dispose() {
    userListener?.cancel();
    chatCardListener?.cancel();
    super.dispose();
  }
}
