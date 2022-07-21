import 'package:flutter/src/widgets/framework.dart';
import 'package:validation/validation.dart';

import '../../../apis/apis.dart';
import '../../../models/models.dart';
import '../screens.dart';
import 'chatBubble/message_bubble.dart';
import 'chat_messaging_model.dart';
import 'chat_messaging_view.dart';

class ChatMessagingProvider
    extends AuthenticatedProvider<ChatMessagingModel, ChatMessagingView> {
  final Conversation conversation;

  const ChatMessagingProvider({Key? key, required this.conversation})
      : super(key: key);

  @override
  Future<bool> init(BuildContext context, ChatMessagingModel model) async {
    if (!await super.init(context, model)) {
      return false;
    }

    model.messageBubbles =
        (await DatabaseApi.instance.getMessages(conversation.conversationId))
            .map((message) => message.sender == AuthApi.instance.userId
                ? SentMessageBubble(message: message.message)
                : ReceivedMessageBubble(message: message.message))
            .toList();

    return true;
  }

  Future<void> onSendMessage(String? message, ChatMessagingModel model) async {
    model.messageFocus.unfocus();
    if (validateChatMessage(message) == null) {
      model.messageController.clear();
      model.scrollController.jumpTo(0);
      await DatabaseApi.instance
          .sendMessage(conversation.conversationId, message!);
      model.addMessageBubble(SentMessageBubble(message: message));
    }
  }

  @override
  ChatMessagingView build(BuildContext context, ChatMessagingModel model) =>
      ChatMessagingView(
          messageController: model.messageController,
          fullName: model.chatName ?? '',
          messageBubbles: model.messageBubbles,
          focusNode: model.messageFocus,
          scrollController: model.scrollController,
          onSendMessage: (message) => onSendMessage(message, model));

  @override
  ChatMessagingModel createModel() => ChatMessagingModel();
}
