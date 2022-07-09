import 'package:flutter/src/widgets/framework.dart';

import '../../../apis/api.dart';
import '../../../models/models.dart';
import '../screens.dart';
import 'chatBubble/received_message_bubble.dart';
import 'chatBubble/sent_message_bubble.dart';
import 'chat_messaging_model.dart';
import 'chat_messaging_view.dart';

class ChatMessagingProvider
    extends AuthenticatedProvider<ChatMessagingModel, ChatMessagingView> {
  static const int kMessageBatchSize = 10;
  final Conversation conversation;

  const ChatMessagingProvider({Key? key, required this.conversation})
      : super(key: key);

  @override
  Future<bool> init(BuildContext context, ChatMessagingModel model) async {
    if (!await super.init(context, model)) {
      return false;
    }

    String otherUserId = conversation.participants
        .firstWhere((userId) => userId != model.currentUser.userId);

    model.userStream = await api<SocialApi>()
        .streamUserInfo(otherUserId)
        .listen((userInfo) => model.otherUser = userInfo);

    model.messageStream = api<SocialApi>()
        .streamMessages(model.currentUser.userId, conversation.conversationId,
            quantity: kMessageBatchSize)
        .map((messages) => messages.map((message) {
              if (message.authorId == otherUserId) {
                api<SocialApi>().updateReadStatus(
                    conversationId: conversation.conversationId,
                    messageId: message.messageId);
                return ReceivedMessageBubble(
                  message: message.text,
                );
              } else {
                return SentMessageBubble(
                  message: message.text,
                );
              }
            }).toList())
        .listen((messageBubbles) => model.messageBubbles = messageBubbles);

    return true;
  }

  @override
  ChatMessagingView build(BuildContext context, ChatMessagingModel model) =>
      ChatMessagingView(
        fullName: model.otherUser?.fullName ?? '',
        messageBubbles: model.messageBubbles,
      );

  @override
  ChatMessagingModel createModel() => ChatMessagingModel();
}
