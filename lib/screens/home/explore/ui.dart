import 'package:flutter/material.dart';

import '../ui.dart';
import 'widgets/empty_page.dart';
import 'widgets/user_page.dart';

class ExploreScreen extends StatelessWidget {
  final List<UserExplore> users;
  final PageController pageController;

  const ExploreScreen({
    super.key,
    required this.users,
    required this.pageController,
  }) : super();

  @override
  Widget build(BuildContext context) => users.isEmpty
      ? const EmptyPage()
      : PageView(
          controller: pageController,
          children: users
              .map(
                (user) => UserPage(
                  user: user,
                ),
              )
              .toList(),
        );
}
