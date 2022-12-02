import 'package:flutter/material.dart';

import '../provider.dart';
import 'message_state.dart';
import 'message_view.dart';

class MessageProvider extends ScreenProvider<MessageState, MessageView> {
  @override
  MessageView build(BuildContext context, MessageState state) => MessageView(
        msg: state.message,
        messageController: state.messageController,
        sendMsg: () {},
      );

  @override
  MessageState buildState() => MessageState();
}
