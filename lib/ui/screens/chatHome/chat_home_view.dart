import 'package:flutter/material.dart';

import '../../common/widgets/widgets.dart';
import '../screen_view.dart';

class ChatHomeView extends ScreenView {
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
