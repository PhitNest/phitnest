import 'package:flutter/material.dart';

import '../base_view.dart';
import '../providers.dart';

/// This is the view shown when users have been authenticated.
class HomeView extends BaseView {
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
