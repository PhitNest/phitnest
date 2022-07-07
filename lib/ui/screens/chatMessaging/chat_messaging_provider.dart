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
  final UserPublicInfo otherUser;

  const ChatMessagingProvider({Key? key, required this.otherUser})
      : super(key: key);

  @override
  Future<bool> init(BuildContext context, ChatMessagingModel model) async {
    if (!await super.init(context, model)) {
      return false;
    }

    UserModel user = (await api<SocialApi>().getFullUserModel(
        (await api<AuthenticationApi>().getAuthenticatedUid())!))!;

    model.messageListener = api<SocialApi>()
        .streamMessagesBetweenUsers(user.userId, otherUser.userId,
            quantity: kMessageBatchSize)
        .map((messages) => messages.map((message) {
              if (message.recipientId == user.userId) {
                api<SocialApi>().updateReadStatus(message.messageId);
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
        fullName: otherUser.fullName,
        messageBubbles: model.messageBubbles,
      );

  @override
  ChatMessagingModel createModel() => ChatMessagingModel();
}
