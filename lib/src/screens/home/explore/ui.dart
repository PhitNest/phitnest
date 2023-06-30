import 'package:flutter/material.dart';

import '../bloc/bloc.dart';

class ExploreScreen extends StatelessWidget {
  final List<UserExplore> users;

  const ExploreScreen({
    super.key,
    required this.users,
  }) : super();

  @override
  Widget build(BuildContext context) => Scaffold(
        body: PageView(
          children: users.map((e) => e.profilePicture).toList(),
        ),
      );
}
