import 'package:flutter/material.dart';

import '../screen_view.dart';
import '../screens.dart';

/// This is the view shown when users have been authenticated.
class HomeView extends ScreenView {
  const HomeView() : super();

  @override
  Widget build(BuildContext context) => Scaffold(
        body: PageView(
          children: [
            ProfileProvider(),
            ChatHomeProvider(),
          ],
        ),
      );
}
