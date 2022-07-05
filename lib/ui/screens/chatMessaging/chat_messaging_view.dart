import 'package:flutter/material.dart';

import '../../common/widgets/widgets.dart';
import '../screen_view.dart';
import 'chatBubble/message_bubble.dart';

class ChatMessagingView extends ScreenView {
  final String fullName;
  final List<MessageBubble> messageBubbles;

  const ChatMessagingView({
    Key? key,
    required this.fullName,
    required this.messageBubbles,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: BackButtonAppBar(),
      body: Column(
        children: messageBubbles,
      ));
}
