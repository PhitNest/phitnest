// ignore_for_file: must_be_immutable

import 'package:flutter/src/widgets/framework.dart';
import 'package:phitnest/services/services.dart';
import 'package:phitnest/ui/screens/chatMessaging/chatBubble/received_message_bubble.dart';
import 'package:phitnest/ui/screens/chatMessaging/chatBubble/sent_message_bubble.dart';

import '../../../models/models.dart';
import '../screens.dart';
import 'chat_messaging_model.dart';
import 'chat_messaging_view.dart';

class ChatMessagingProvider
    extends ScreenProvider<ChatMessagingModel, ChatMessagingView> {
  static const int kMessageBatchSize = 10;
  final UserPublicInfo? user;

  ChatMessagingProvider({Key? key, required this.user}) : super(key: key);

  @override
  Future<bool> init(BuildContext context, ChatMessagingModel model) async {
    if (!await super.init(context, model) || user == null) {
      return false;
    }

    model.messageStream = chatService
        .getRecentChatMessagesToAndFrom(user!.userId)
        .listen((message) {
      if (message != null) {
        if (message.authorId == user!.userId) {
          model.addMessageBubble(ReceivedMessageBubble(message: message.text));
        } else {
          model.addMessageBubble(SentMessageBubble(message: message.text));
        }
      }
    });

    return true;
  }

  @override
  ChatMessagingView build(BuildContext context, ChatMessagingModel model) =>
      ChatMessagingView(
        fullName: user?.fullName ?? '',
        messageBubbles: model.messageBubbles,
      );

  @override
  ChatMessagingModel createModel() => ChatMessagingModel();
}
