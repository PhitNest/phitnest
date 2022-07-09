import 'dart:async';

import '../../../../../models/models.dart';
import '../../../screens.dart';

class ChatCardModel extends AuthenticatedModel {
  UserPublicInfo? _otherUser;
  StreamSubscription<UserPublicInfo?>? userStream;

  UserPublicInfo? get otherUser => _otherUser;

  set otherUser(UserPublicInfo? otherUser) {
    _otherUser = otherUser;
    notifyListeners();
  }

  ChatMessage? _message;
  StreamSubscription<ChatMessage>? messageStream;

  ChatMessage? get message => _message;

  set message(ChatMessage? message) {
    _message = message;
    notifyListeners();
  }

  @override
  void dispose() {
    userStream?.cancel();
    messageStream?.cancel();
    super.dispose();
  }
}
