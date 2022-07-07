import 'package:flutter/material.dart';

import 'chatCard/chat_card.dart';

class ChatHome extends StatelessWidget {
  final List<ChatCard> cards;

  const ChatHome({Key? key, required this.cards}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
          body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 32.0),
        child:
            Column(mainAxisAlignment: MainAxisAlignment.start, children: cards),
      ));
}
