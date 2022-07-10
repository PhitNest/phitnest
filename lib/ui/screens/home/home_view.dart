import 'package:flutter/material.dart';

import '../screen_view.dart';
import '../screens.dart';
import 'chatHome/chatCard/chat_card.dart';
import 'chatHome/chat_home.dart';

/// This is the view shown when users have been authenticated.
class HomeView extends ScreenView {
  final PageController pageController;
  final List<ChatCard> cards;

  const HomeView({Key? key, required this.pageController, required this.cards})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        body: PageView(
          controller: pageController,
          children: [
            ProfileProvider(),
            ChatHome(cards: cards),
          ],
        ),
      );
}
