import 'package:flutter/material.dart';

import '../../../entities/entities.dart';
import '../../../repositories/repositories.dart';
import '../../../use-cases/use_cases.dart';
import '../provider.dart';
import 'message_state.dart';
import 'message_view.dart';

class MessageProvider extends ScreenProvider<MessageState, MessageView> {
  final ConversationEntity? conversation;
  final FriendEntity? friend;

  const MessageProvider({this.conversation, this.friend})
      : assert(conversation != null || friend != null),
        super();

  @override
  Future<void> init(BuildContext context, MessageState state) async {
    if (conversation != null) {
      state.conversation = conversation;

      state.loading = true;
      state.errorMessage = null;
      getMessagesUseCase.getMessages(state.conversation!.id).then(
        (either) {
          state.loading = false;
          return either.fold(
            (messages) => state.messages = messages.reversed.toList(),
            (failure) => state.errorMessage = failure.message,
          );
        },
      );
    } else if (friend != null) {
      state.messages = [];
    }
  }

  @override
  MessageView build(BuildContext context, MessageState state) => MessageView(
        scrollController: state.scrollController,
        loading: state.loading,
        errorMessage: state.errorMessage,
        messageFocus: state.messageFocus,
        onPressedRetry: () => init(context, state),
        messages: state.messages
            ?.map(
              (message) => MessageCard(
                sentByMe:
                    message.userCognitoId == memoryCacheRepo.me!.cognitoId,
                message: message.text,
              ),
            )
            .toList(),
        messageController: state.messageController,
        onPressSend: () {
          state.messageFocus.unfocus();
          if (state.messageController.text.isNotEmpty) {
            state.addMessage(
              new MessageEntity(
                id: '0',
                conversationId: state.conversation?.id ?? '0',
                text: state.messageController.text,
                userCognitoId: memoryCacheRepo.me!.cognitoId,
                createdAt: DateTime.now(),
              ),
            );
            if (state.conversation == null) {
              state.conversation = new ConversationEntity(
                id: '0',
                users: [
                  memoryCacheRepo.me!,
                  friend!,
                ],
              );
            }
            state.messageController.clear();
          }
        },
        name: state.conversation?.users
                .firstWhere(
                    (user) => user.cognitoId != memoryCacheRepo.me!.cognitoId)
                .fullName ??
            friend!.fullName,
      );

  @override
  MessageState buildState() => MessageState();
}
