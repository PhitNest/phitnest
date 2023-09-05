import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:ui/ui.dart';

import '../../../../entities/entities.dart';
import '../navbar/navbar.dart';
import 'widgets/widgets.dart';

part 'bloc.dart';

class ExploreScreen extends StatelessWidget {
  final PageController pageController;
  final List<UserExploreWithPicture> users;
  final NavBarState navBarState;

  const ExploreScreen({
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
