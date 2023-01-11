import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import '../../../entities/entities.dart';
import '../../../repositories/repositories.dart';
import '../../../use-cases/use_cases.dart';
import '../../widgets/widgets.dart';
import '../screen_provider.dart';
import '../screens.dart';
import 'conversations_state.dart';
import 'conversations_view.dart';

class ConversationsProvider
    extends ScreenProvider<ConversationsCubit, ConversationsState> {
  const ConversationsProvider() : super();

  /// This is a helper function that takes a list of conversations and friends and combines
  /// them into a single list sorted by the most recent message or friend request.
  List<Either<FriendEntity, Tuple2<ConversationEntity, MessageEntity>>>
      produceConversationList(
    List<Tuple2<ConversationEntity, MessageEntity>> conversations,
    List<FriendEntity> friends,
  ) {
    // Remove friends that are already in a direct conversation
    friends.removeWhere(
      (friend) =>
          conversations.indexWhere(
            (conversation) =>
                conversation.value1.users.indexWhere(
                      (user) => user.cognitoId == friend.cognitoId,
                    ) !=
                    -1 &&
                !conversation.value1.isGroup,
          ) !=
          -1,
    );
    final List<Either<FriendEntity, Tuple2<ConversationEntity, MessageEntity>>>
        recents = [];
    int friendIndex = 0;
    int conversationIndex = 0;
    while (friendIndex < friends.length ||
        conversationIndex < conversations.length) {
      if (conversationIndex == conversations.length) {
        recents.add(
          Left(
            friends[friendIndex],
          ),
        );
        friendIndex++;
      } else if (friendIndex == friends.length ||
          conversations[conversationIndex]
              .value2
              .createdAt
              .isAfter(friends[friendIndex].since)) {
        recents.add(
          Right(
            conversations[conversationIndex],
          ),
        );
        conversationIndex++;
      } else {
        recents.add(
          Left(
            friends[friendIndex],
          ),
        );
        friendIndex++;
      }
    }
    return recents;
  }

  void onPressedFriends(BuildContext context) => Navigator.push(
        context,
        NoAnimationMaterialPageRoute(
          builder: (context) => FriendsProvider(),
        ),
      );

  @override
  Future<void> listener(
    BuildContext context,
    ConversationsCubit cubit,
    ConversationsState state,
  ) async {
    if (state is LoadingState) {
      if (memoryCacheRepo.me == null) {
        await getUserUseCase.getUser();
      }
      if (memoryCacheRepo.me == null) {
        Navigator.pushAndRemoveUntil(
          context,
          NoAnimationMaterialPageRoute(
            builder: (context) => UnauthorizedProvider(),
          ),
          (route) => false,
        );
      } else {
        Future.wait([
          getConversationsUseCase.recents(),
          getFriendsUseCase.friends(),
          streamDirectMessageUseCase.streamDirectMessage(),
          streamMessagesUseCase.streamMessages(),
        ]).then(
          (eithers) => eithers[0].fold(
            (conversations) => eithers[1].fold(
              (friends) => eithers[2].fold(
                (directMessageStream) => eithers[3].fold(
                  (messageStream) => cubit.transitionToLoaded(
                    produceConversationList(
                      conversations
                          as List<Tuple2<ConversationEntity, MessageEntity>>,
                      friends as List<FriendEntity>,
                    ),
                    (messageStream as Stream<MessageEntity>).listen(
                      (message) => cubit.updateExistingConversation(message),
                    ),
                    (directMessageStream as Stream<
                            Tuple2<ConversationEntity, MessageEntity>>)
                        .listen(
                      (pair) => cubit.addNewConversation(pair),
                    ),
                  ),
                  (failure) => cubit.transitionToError(failure.message),
                ),
                (failure) => cubit.transitionToError(failure.message),
              ),
              (failure) => cubit.transitionToError(failure.message),
            ),
            (failure) => cubit.transitionToError(failure.message),
          ),
        );
      }
    } else if (state is LoadedState) {
      if (state.conversations.length == 0) {
        cubit.transitionToNoConversations();
      }
    }
  }

  @override
  Widget builder(
    BuildContext context,
    ConversationsCubit cubit,
    ConversationsState state,
  ) {
    if (state is LoadingState) {
      return LoadingView(
        onPressedFriends: () => onPressedFriends(context),
      );
    } else if (state is LoadedState) {
      return LoadedView(
        conversations: state.conversations,
        onPressedFriends: () => onPressedFriends(context),
        onTapFriend: (friend) => Navigator.pushAndRemoveUntil(
          context,
          NoAnimationMaterialPageRoute(
            builder: (context) => MessageProvider(friend: friend),
          ),
          (_) => false,
        ),
        onTapConversation: (conversation) => Navigator.pushAndRemoveUntil(
          context,
          NoAnimationMaterialPageRoute(
            builder: (context) => MessageProvider(conversation: conversation),
          ),
          (_) => false,
        ),
        getChatName: (conversation) =>
            conversation.chatName(memoryCacheRepo.me!.id),
      );
    } else if (state is ErrorState) {
      return ErrorView(
        onPressedFriends: () => onPressedFriends(context),
        errorMessage: state.message,
        onPressedRetry: () => cubit.transitionToLoading(),
      );
    } else if (state is NoConversationsState) {
      return NoConversationsView(
        onPressedFriends: () => onPressedFriends(context),
      );
    } else {
      throw Exception('Unknown state: $state');
    }
  }

  @override
  ConversationsCubit buildCubit() => ConversationsCubit();
}
