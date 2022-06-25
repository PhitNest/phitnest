import 'dart:async';

import '../base_model.dart';

class ChatListenerModel extends BaseModel {
  StreamSubscription<dynamic>? chatStream;

  @override
  void dispose() {
    chatStream?.cancel();
    super.dispose();
  }
}
