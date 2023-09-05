import 'package:flutter/material.dart';

import '../../../../entities/entities.dart';
import '../navbar/navbar.dart';
import 'widgets/widgets.dart';

class ExplorePage extends StatelessWidget {
  final PageController pageController;
  final List<UserExploreWithPicture> users;
  final NavBarState navBarState;

  const ExplorePage({
    super.key,
    required this.pageController,
    required this.users,
    required this.navBarState,
  }) : super();

  @override
  Widget build(BuildContext context) => users.isEmpty
      ? const EmptyPage()
      : PageView.builder(
          controller: pageController,
          itemBuilder: (context, page) => ExploreUserPage(
            countdown: switch (navBarState) {
              NavBarHoldingLogoState(countdown: final countdown) => countdown,
              _ => null,
            },
            user: users[page % users.length],
          ),
        );
}
