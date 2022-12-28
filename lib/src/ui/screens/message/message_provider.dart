import 'package:flutter/material.dart';

import '../../../entities/entities.dart';
import '../../../repositories/repositories.dart';
import '../../../use-cases/use_cases.dart';
import '../screen_provider.dart';
import 'message_state.dart';
import 'message_view.dart';

class MessageProvider extends ScreenProvider<MessageCubit, MessageState> {
  final messageController = TextEditingController();
  final messageFocus = FocusNode();
  final scrollController = ScrollController();
  final ConversationEntity? conversation;
  final FriendEntity? friend;

  MessageProvider({this.conversation, this.friend})
      : assert(conversation != null || friend != null),
        assert(memoryCacheRepo.me != null),
        super();

  @override
  Future<void> listener(
    BuildContext context,
    MessageCubit cubit,
    MessageState state,
  ) async {
    if (state is InitialState) {
      if (conversation != null) {
        cubit.transitionToLoading(conversation!);
      } else {
        cubit.transitionToNewFriend(friend!);
      }
    } else if (state is LoadingConversationState) {
      Future.wait([
        getMessagesUseCase.getMessages(state.conversation.id),
        streamMessagesUseCase.streamMessages(state.conversation.id)
      ]).then(
        (eithers) => eithers[0].fold(
          (messages) => eithers[1].fold(
            (messageStream) => cubit.transitionToLoaded(
              state.conversation,
              (messages as List<MessageEntity>).reversed.toList(),
              (messageStream as Stream<MessageEntity>).listen(
                (message) => cubit.addMessage(message),
              ),
            ),
            (failure) => cubit.transitionToError(failure.message),
          ),
          (failure) => cubit.transitionToError(failure.message),
        ),
      );
    }
  }

  @override
  Widget builder(
    BuildContext context,
    MessageCubit cubit,
    MessageState state,
  ) {
    if (state is InitialState) {
      return InitialView();
    } else if (state is LoadingConversationState) {
      return LoadingConversationView(
        onPressedSend: () => messageFocus.unfocus(),
        messageController: messageController,
        messageFocus: messageFocus,
        name: state.conversation.chatName(memoryCacheRepo.me!.id),
      );
    } else if (state is LoadedState) {
      return MessageView(
        messages: state.messages,
        isMe: (message) =>
            message.userCognitoId == memoryCacheRepo.me!.cognitoId,
        onPressedSend: () {
          messageFocus.unfocus();
          scrollController.animateTo(0,
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut);
          if (messageController.text.trim().length > 0) {
            sendMessageUseCase
                .sendMessage(
                    state.conversation.id, messageController.text.trim())
                .then(
                  (either) => either.fold(
                    (message) => cubit.addMessage(message),
                    (failure) => cubit.transitionToError(failure.message),
                  ),
                );
          }
          messageController.clear();
        },
        messageController: messageController,
        messageFocus: messageFocus,
        name: state.conversation.chatName(memoryCacheRepo.me!.id),
        scrollController: scrollController,
      );
    } else if (state is NewFriendState) {
      return NewFriendView(
        name: state.friend.fullName,
        onPressedSend: () {
          messageFocus.unfocus();
          if (messageController.text.trim().length > 0) {
            sendDirectMessageUseCase
                .sendDirectMessage(
                    state.friend.cognitoId, messageController.text.trim())
                .then(
                  (either) => either.fold(
                    (pair) => streamMessagesUseCase
                        .streamMessages(pair.value1.id)
                        .then(
                          (either) => either.fold(
                            (messageStream) => cubit.transitionToLoaded(
                              pair.value1,
                              [pair.value2],
                              messageStream.listen(
                                (message) => cubit.addMessage(message),
                              ),
                            ),
                            (failure) =>
                                cubit.transitionToError(failure.message),
                          ),
                        ),
                    (failure) => cubit.transitionToError(failure.message),
                  ),
                );
          }
          messageController.clear();
        },
        messageController: messageController,
        messageFocus: messageFocus,
      );
    } else if (state is ErrorState) {
      return ErrorView(
        onPressedSend: () => messageFocus.unfocus(),
        messageController: messageController,
        messageFocus: messageFocus,
        name:
            conversation?.chatName(memoryCacheRepo.me!.id) ?? friend!.fullName,
        onPressedRetry: () => conversation != null
            ? cubit.transitionToLoading(conversation!)
            : cubit.transitionToNewFriend(friend!),
        message: state.message,
      );
    } else {
      throw Exception('Unknown state: $state');
    }
  }

  @override
  MessageCubit buildCubit() => MessageCubit();

  @override
  void dispose() {
    messageController.dispose();
    messageFocus.dispose();
    scrollController.dispose();
    super.dispose();
  }
}
