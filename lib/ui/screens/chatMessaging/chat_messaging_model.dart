import 'dart:async';

import 'chatBubble/message_bubble.dart';
import '../screen_model.dart';

class ChatMessagingModel extends ScreenModel {
  StreamSubscription<List<MessageBubble>>? messageListener;
  List<MessageBubble> _messageBubbles = [];

  List<MessageBubble> get messageBubbles => _messageBubbles;

  set messageBubbles(List<MessageBubble> messageBubbles) {
    _messageBubbles = messageBubbles;
    notifyListeners();
  }

  @override
  void dispose() {
    messageListener?.cancel();
    super.dispose();
  }
}
