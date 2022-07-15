import 'package:flutter/material.dart';

import '../../../screen_view.dart';
import 'chatCard/chat_card.dart';

export 'chatCard/chat_card.dart';

class ChatHomeView extends ScreenView {
  final List<ChatCard> cards;

  const ChatHomeView({Key? key, required this.cards}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
          body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 32.0),
        child:
            Column(mainAxisAlignment: MainAxisAlignment.start, children: cards),
      ));
}
