import 'dart:async';

import '../models.dart';

class ChatListenerModel extends BaseModel {
  StreamSubscription<dynamic>? chatStream;

  @override
  void dispose() {
    chatStream?.cancel();
    super.dispose();
  }
}
