import 'package:flutter/material.dart';

import '../../screen_view.dart';
import '../../screens.dart';
import 'home_view.dart';

export 'chatHome/chat_home_view.dart';
export 'profile/profile_view.dart';

/// This is the view shown when users have been authenticated.
class HomeView extends ScreenView {
  final PageController pageController;
  final List<ChatCard> messageCards;

  const HomeView({
    Key? key,
    required this.pageController,
    required this.messageCards,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        body: PageView(
          controller: pageController,
          // Swipe right to see each individual childs
          children: [
            ChatHomeProvider(messageCards: messageCards),
          ],
        ),
      );
}
