import 'package:flutter/material.dart';

import '../../../models/models.dart';
import '../screen_view.dart';
import 'chatHome/chatCard/chat_card.dart';
import 'chatHome/chat_home.dart';
import 'profileView/profile_view.dart';

/// This is the view shown when users have been authenticated.
class HomeView extends ScreenView {
  final AuthenticatedUser user;
  final PageController pageController;
  final List<ChatCard> cards;

  const HomeView({
    Key? key,
    required this.pageController,
    required this.cards,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        body: PageView(
          controller: pageController,
          children: [
            ProfileView(user: user),
            ChatHome(cards: cards),
          ],
        ),
      );
}
