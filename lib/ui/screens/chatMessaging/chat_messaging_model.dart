import 'dart:async';

import 'package:flutter/material.dart';

import '../../../models/models.dart';
import '../screens.dart';
import 'chatBubble/message_bubble.dart';

class ChatMessagingModel extends AuthenticatedModel {
  TextEditingController messageController = TextEditingController();
  FocusNode messageFocus = FocusNode();

  ScrollController scrollController = ScrollController();

  StreamSubscription<UserPublicInfo?>? userStream;
  UserPublicInfo? _otherUser;

  UserPublicInfo? get otherUser => _otherUser;

  set otherUser(UserPublicInfo? otherUser) {
    _otherUser = otherUser;
    notifyListeners();
  }

  StreamSubscription<List<MessageBubble>>? messageStream;

  List<MessageBubble> _messageBubbles = [];
  List<MessageBubble> get messageBubbles => _messageBubbles;

  set messageBubbles(List<MessageBubble> messageBubbles) {
    _messageBubbles = messageBubbles;
    notifyListeners();
  }

  @override
  void dispose() {
    messageStream?.cancel();
    userStream?.cancel();
    super.dispose();
  }
}
