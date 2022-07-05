import 'dart:async';

import 'package:phitnest/ui/screens/screen_model.dart';

import '../../../models/models.dart';
import 'chatCard/chat_card.dart';

class ChatHomeModel extends ScreenModel {
  StreamSubscription<UserPublicInfo?>? userStream;

  List<ChatCard> _chatCards = [];

  List<ChatCard> get chatCards => _chatCards;

  void addCard(ChatCard card) {
    int insertIndex = _chatCards.indexWhere((element) => card < element);
    _chatCards.insert(
        insertIndex == -1 ? _chatCards.length : insertIndex, card);
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
