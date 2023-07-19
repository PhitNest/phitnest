import 'package:flutter/material.dart';
import 'package:phitnest_core/core.dart';

import '../../widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  final ApiInfo apiInfo;

  const HomeScreen({
    super.key,
    required this.apiInfo,
  }) : super();

  @override
  Widget build(BuildContext context) => Scaffold(
        body: StyledNavBar(
          listener: (context, navBarState) async {},
          builder: (context, navBarState) => switch (navBarState.page) {
            NavBarPage.news => Container(),
            NavBarPage.explore => Container(),
            NavBarPage.chat => Container(),
            NavBarPage.options => Container(),
          },
        ),
      );
}
