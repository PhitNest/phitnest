import 'package:flutter/material.dart';

import '../provider.dart';
import 'message_state.dart';
import 'message_view.dart';
import 'widgets/widgets.dart';

class MessageProvider extends ScreenProvider<MessageState, MessageView> {
  const MessageProvider() : super();

  @override
  MessageView build(BuildContext context, MessageState state) => MessageView(
        messageFocus: state.messageFocus,
        messages: state.message
            .map(
              (message) => MessageCard(
                sentByMe: message.userCognitoId == state.myCognitoId,
                message: message.text,
              ),
            )
            .toList(),
        messageController: state.messageController,
        onPressSend: state.sendMessage,
        scrollController: state.scrollController,
        name: state.users
            .firstWhere((user) => user.cognitoId != state.myCognitoId)
            .fullName,
      );

  @override
  MessageState buildState() => MessageState();
}
