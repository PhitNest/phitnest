import 'package:flutter/material.dart';

import '../../../../models/models.dart';
import '../../screen_view.dart';
import '../../screens.dart';
import 'home_view.dart';

export 'chatHome/chat_home_view.dart';
export 'profileView/profile_view.dart';

/// This is the view shown when users have been authenticated.
class HomeView extends ScreenView {
  final PageController pageController;
  final List<ChatCard> messageCards;
  final AuthenticatedUser currentUser;

  const HomeView({
    Key? key,
    required this.pageController,
    required this.messageCards,
    required this.currentUser,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        body: PageView(
          controller: pageController,
          children: [
            ProfileProvider(
              firstName: currentUser.firstName,
              lastName: currentUser.lastName,
              bio: currentUser.bio,
              profilePictureUrl: currentUser.profilePictureUrl,
            ),
            ChatHomeProvider(messageCards: messageCards),
          ],
        ),
      );
}
