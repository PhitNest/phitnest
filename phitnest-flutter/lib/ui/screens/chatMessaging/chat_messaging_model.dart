import 'package:flutter/material.dart';

import '../screen_model.dart';
import 'chatBubble/message_bubble.dart';

class ChatMessagingModel extends ScreenModel {
  String? chatName;
  TextEditingController messageController = TextEditingController();
  FocusNode messageFocus = FocusNode();

  ScrollController scrollController = ScrollController();

  List<MessageBubble> _messageBubbles = [];
  List<MessageBubble> get messageBubbles => _messageBubbles;

  set messageBubbles(List<MessageBubble> messageBubbles) {
    _messageBubbles = messageBubbles;
    notifyListeners();
  }

  addMessageBubble(MessageBubble messageBubble) {
    _messageBubbles.insert(0, messageBubble);
    notifyListeners();
  }
}
