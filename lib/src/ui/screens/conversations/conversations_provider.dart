import 'package:flutter/material.dart';

import '../../widgets/widgets.dart';
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
          NoAnimationMaterialPageRoute(
            builder: (context) => const FriendsProvider(),
          ),
        ),
        onTapLogoButton: () => Navigator.push(
          context,
          NoAnimationMaterialPageRoute(
            builder: (context) => const ExploreProvider(),
          ),
        ),
        conversations: state.conversations
            .asMap()
            .entries
            .map(
              (element) => ConversationCard(
                message: element.value.value2.text,
                title: element.value.value1.fullName,
                onDismissed: (_) => state.removeConversation(element.key),
                onTap: () {},
              ),
            )
            .toList(),
      );

  @override
  ConversationsState buildState() => ConversationsState();
}
