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
  ConversationsProvider() : super();

  @override
  Future<void> listener(
    BuildContext context,
    ConversationsCubit cubit,
    ConversationsState state,
  ) async {
    if (state is LoadingState) {
      if (memoryCacheRepo.me == null) {
        Navigator.pushAndRemoveUntil(
          context,
          NoAnimationMaterialPageRoute(
            builder: (context) => UnauthorizedProvider(),
          ),
          (route) => false,
        );
      } else {
        getConversationsUseCase.recents().then(
              (conversationEither) => conversationEither.fold(
                (conversations) => getFriendsUseCase.friends().then(
                      (friendsEither) => friendsEither.fold(
                        (friends) {
                          // Remove friends that are already in a direct conversation
                          friends.removeWhere(
                            (friend) =>
                                conversations.indexWhere(
                                  (conversation) =>
                                      conversation.value1.users.indexWhere(
                                            (user) =>
                                                user.cognitoId ==
                                                friend.cognitoId,
                                          ) !=
                                          -1 &&
                                      !conversation.value1.isGroup,
                                ) !=
                                -1,
                          );
                          final List<
                              Either<
                                  FriendEntity,
                                  Tuple2<ConversationEntity,
                                      MessageEntity>>> recents = [];
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
                          cubit.transitionToLoaded(recents);
                        },
                        (failure) => cubit.transitionToError(failure.message),
                      ),
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
        onPressedFriends: () => Navigator.push(
          context,
          NoAnimationMaterialPageRoute(
            builder: (context) => FriendsProvider(),
          ),
        ),
      );
    } else if (state is LoadedState) {
      return LoadedView(
        conversations: state.conversations,
        onPressedFriends: () => Navigator.push(
          context,
          NoAnimationMaterialPageRoute(
            builder: (context) => FriendsProvider(),
          ),
        ),
        onDismissFriend: (friend, index) => cubit.removeConversation(index),
        onDismissConversation: (conversation, index) =>
            cubit.removeConversation(index),
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
        onPressedFriends: () => Navigator.push(
          context,
          NoAnimationMaterialPageRoute(
            builder: (context) => FriendsProvider(),
          ),
        ),
        errorMessage: state.message,
        onPressedRetry: () => cubit.transitionToLoading(),
      );
    } else if (state is NoConversationsState) {
      return NoConversationsView(
        onPressedFriends: () => Navigator.push(
          context,
          NoAnimationMaterialPageRoute(
            builder: (context) => FriendsProvider(),
          ),
        ),
      );
    } else {
      throw Exception('Unknown state: $state');
    }
  }

  @override
  ConversationsCubit buildCubit() => ConversationsCubit();
}
