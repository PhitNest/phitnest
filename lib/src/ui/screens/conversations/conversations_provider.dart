import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import '../../../entities/entities.dart';
import '../../../repositories/repositories.dart';
import '../../../use-cases/use_cases.dart';
import '../../widgets/widgets.dart';
import '../provider.dart';
import '../screens.dart';
import 'conversations_state.dart';
import 'conversations_view.dart';
import 'widgets/widgets.dart';

class ConversationsProvider
    extends ScreenProvider<ConversationsState, ConversationsView> {
  @override
  Future<void> init(BuildContext context, ConversationsState state) async {
    state.loading = true;
    state.errorMessage = null;
    Future.wait(
        [getConversationsUseCase.recents(), getFriendsUseCase.friends()]).then(
      (eithers) {
        state.loading = false;
        if (eithers[0].isRight() && eithers[1].isRight()) {
          state.errorMessage = 'Something went wrong';
        } else if (eithers[0].isRight()) {
          state.errorMessage = eithers[0]
              .getOrElse(() => Failure('Something went wrong'))
              .message;
        } else if (eithers[1].isRight()) {
          state.errorMessage = eithers[1]
              .getOrElse(() => Failure('Something went wrong'))
              .message;
        } else {
          state.conversations = List.castFrom(eithers[0].swap().getOrElse(
              () => [] as List<Tuple2<ConversationEntity, MessageEntity>>));
          state.friends = List.castFrom(
              eithers[1].swap().getOrElse(() => [] as List<FriendEntity>));
        }
      },
    );
  }

  const ConversationsProvider() : super();

  @override
  ConversationsView build(BuildContext context, ConversationsState state) {
    final conversationCards = state.conversations.asMap().entries.map((entry) {
      if (!entry.value.value1.isGroup) {
        state.friends.removeAt(state.friends.indexWhere((friend) =>
            entry.value.value1.users
                .indexWhere((user) => friend.cognitoId == user.cognitoId) !=
            -1));
      }
      return ConversationCard(
        message: entry.value.value2.text,
        title: entry.value.value1.chatName(memoryCacheRepo.me!.id),
        onDismissed: (_) => state.removeConversation(entry.key),
        time: entry.value.value2.createdAt,
        onTap: () => Navigator.push(
          context,
          NoAnimationMaterialPageRoute(
            builder: (context) => const MessageProvider(),
          ),
        ),
      );
    }).toList();
    for (int i = 0; i < state.friends.length; i++) {
      final friendCard = ConversationCard(
        title: state.friends[i].fullName,
        onDismissed: (_) => state.removeFriend(i),
        onTap: () => Navigator.push(
          context,
          NoAnimationMaterialPageRoute(
            builder: (context) => const MessageProvider(),
          ),
        ),
        time: state.friends[i].since,
        message:
            "You have just connected with ${state.friends[i].fullName}, say hello!",
      );
      bool inserted = false;
      for (int j = 0; j < conversationCards.length; j++) {
        if (state.friends[i].since.isBefore(conversationCards[j].time)) {
          conversationCards.insert(j, friendCard);
          inserted = true;
          break;
        }
      }
      if (!inserted) {
        conversationCards.add(friendCard);
      }
    }
    return ConversationsView(
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
      conversations: conversationCards,
      loading: state.loading,
      errorMessage: state.errorMessage,
      onPressedRetry: () => init(context, state),
    );
  }

  @override
  ConversationsState buildState() => ConversationsState();
}
