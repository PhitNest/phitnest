import 'package:flutter/material.dart';
import 'package:phitnest_mobile/src/ui/screens/friends/friends_provider.dart';

import '../provider.dart';
import 'chat_state.dart';
import 'chat_view.dart';

class ChatProvider extends ScreenProvider<ChatState, ChatView> {
  @override
  ChatView build(BuildContext context, ChatState state) => ChatView(
        onClickColor: state.onClickColor,
        onClickMessage: () => state.setMessageColor = Color(0xFFFFE3E3),
        onClickFriends: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FriendProvider(),
          ),
        ),
      );

  @override
  ChatState buildState() => ChatState();
}
