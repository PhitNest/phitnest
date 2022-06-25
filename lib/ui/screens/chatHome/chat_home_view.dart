import 'package:flutter/material.dart';

import '../base_view.dart';
import 'chatCard/chat_card.dart';

class ChatHomeView extends BaseView {
  final List<ChatCard> cards;

  ChatHomeView({required this.cards}) : super();

  @override
  Widget build(BuildContext context) => Scaffold(
      body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: cards,
          )));
}
