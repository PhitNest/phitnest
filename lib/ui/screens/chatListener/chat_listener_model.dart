import 'dart:async';

import '../screen_model.dart';

class ChatListenerModel extends ScreenModel {
  StreamSubscription<dynamic>? chatStream;

  @override
  void dispose() {
    chatStream?.cancel();
    super.dispose();
  }
}
