import 'package:flutter/material.dart';

import '../bloc/bloc.dart';

class ExploreScreen extends StatelessWidget {
  final List<UserExplore> users;
  final PageController pageController;

  const ExploreScreen({
    super.key,
    required this.users,
    required this.pageController,
  }) : super();

  @override
  Widget build(BuildContext context) => PageView(
        controller: pageController,
        children: users.map((e) => e.profilePicture).toList(),
      );
}
