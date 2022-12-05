import 'package:flutter/material.dart';

import '../provider.dart';
import '../screens.dart';
import 'conversations_state.dart';
import 'conversations_view.dart';
import 'widgets/widgets.dart';

class ConversationsProvider
    extends ScreenProvider<ConversationsState, ConversationsView> {
  const ConversationsProvider() : super();

  @override
  ConversationsView build(BuildContext context, ConversationsState state) =>
      ConversationsView(
        onClickFriends: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const FriendsProvider(),
          ),
        ),
        conversations: state.conversations
            .asMap()
            .entries
            .map(
              (element) => ConversationCard(
                message: element.value.value2.text,
                title: element.value.value1.fullName,
                selected: element.value.value3,
                onDismissed: (direction) => state.selectConversation(
                  element.key,
                  direction == DismissDirection.startToEnd,
                ),
              ),
            )
            .toList(),
      );

  @override
  ConversationsState buildState() => ConversationsState();
}
