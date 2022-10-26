import 'package:flutter/material.dart';

import '../provider.dart';
import 'chat_state.dart';
import 'chat_view.dart';

class ChatProvider extends ScreenProvider<ChatState, ChatView> {
  @override
  ChatView build(BuildContext context, ChatState state) => ChatView();

  @override
  ChatState buildState() => ChatState();
}
