import 'dart:async';

import '../../../models/models.dart';
import 'chatBubble/message_bubble.dart';
import '../screen_model.dart';

class ChatMessagingModel extends ScreenModel {
  StreamSubscription<ChatMessage?>? messageStream;
  List<MessageBubble> _messageBubbles = [];

  List<MessageBubble> get messageBubbles => _messageBubbles;

  void addMessageBubble(MessageBubble bubble) {
    messageBubbles.add(bubble);
    notifyListeners();
  }

  @override
  void dispose() {
    messageStream?.cancel();
    super.dispose();
  }
}
