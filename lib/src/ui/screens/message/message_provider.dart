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
      getMessagesUseCase.getMessages(state.conversation.id).then(
            (either) => either.fold(
              (messages) => cubit.transitionToLoaded(
                state.conversation,
                messages,
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
      return const InitialView();
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
        isMe: (message) => message.userCognitoId == memoryCacheRepo.me!.id,
        onPressedSend: () {
          messageFocus.unfocus();
          scrollController.animateTo(0,
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut);
          if (messageController.text.trim().length > 0) {
            MessageEntity newMessage = MessageEntity(
              id: '',
              conversationId: state.conversation.id,
              userCognitoId: memoryCacheRepo.me!.id,
              text: messageController.text.trim(),
              createdAt: DateTime.now(),
            );
            cubit.addMessage(newMessage);
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
          scrollController.animateTo(0,
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeInOut);
          if (messageController.text.trim().length > 0) {
            ConversationEntity conversation = ConversationEntity(
              id: '',
              users: [state.friend, memoryCacheRepo.me!],
            );
            MessageEntity newMessage = MessageEntity(
              id: '',
              conversationId: conversation.id,
              userCognitoId: memoryCacheRepo.me!.id,
              text: messageController.text.trim(),
              createdAt: DateTime.now(),
            );
            cubit.transitionToLoaded(conversation, [newMessage]);
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
        name: conversation!.chatName(memoryCacheRepo.me!.id),
        onPressedRetry: () => cubit.transitionToLoading(conversation!),
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
