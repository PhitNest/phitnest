import 'dart:async';

import '../../../models/models.dart';
import '../chatListener/chat_listener_model.dart';
import 'chatCard/chat_card.dart';

class ChatHomeModel extends ChatListenerModel {
  StreamSubscription<UserModel?>? userStream;

  List<int> selectedCardIndices = [];

  List<ChatCard> _chatCards = [];

  List<ChatCard> get chatCards => _chatCards;

  void addCard(ChatCard card) {
    _chatCards.add(card);
    notifyListeners();
  }

  void removeCard(ChatCard card) {
    _chatCards.remove(card);
    notifyListeners();
  }

  @override
  void dispose() {
    userStream?.cancel();
    super.dispose();
  }
}
