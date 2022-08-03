import 'package:flutter/material.dart';

import '../../screen_view.dart';
import '../../screens.dart';

export 'chatHome/chat_home_view.dart';
export 'profile/profile_view.dart';
export 'heatmap/heatmap_view.dart';

/// This is the view shown when users have been authenticated.
class HomeView extends ScreenView {
  final PageController pageController;

  const HomeView({Key? key, required this.pageController}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        body: PageView(
          controller: pageController,
          // Swipe right to see each individual children
          children: [
            ProfileProvider(),
            HeatmapProvider(),
            ChatHomeProvider(),
          ],
        ),
      );
}
