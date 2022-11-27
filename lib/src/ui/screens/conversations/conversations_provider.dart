import 'package:flutter/material.dart';

import '../provider.dart';
import '../screens.dart';
import 'conversations_state.dart';
import 'conversations_view.dart';

class ConversationsProvider
    extends ScreenProvider<ConversationsState, ConversationsView> {
  @override
  ConversationsView build(BuildContext context, ConversationsState state) =>
      ConversationsView(
        conversations: state.conversations,
        onDownTapMessage: (index) => state.selectConversation(index, true),
        onUpTapMessage: (index) => state.selectConversation(index, false),
        onClickFriends: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FriendsProvider(),
          ),
        ),
      );

  @override
  ConversationsState buildState() => ConversationsState();
}
