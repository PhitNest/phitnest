import 'package:flutter/material.dart';

import '../views.dart';
import 'chatCard/chat_card.dart';

class ChatHomeView extends BaseView {
  final List<ChatCard> cards;

  ChatHomeView({required this.cards}) : super();

  @override
  Widget build(BuildContext context) => Scaffold(
          body: Column(
        children: cards,
      ));
}
