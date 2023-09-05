import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:ui/ui.dart';

import '../../../../entities/entities.dart';
import '../../home.dart';
import '../navbar/navbar.dart';
import 'widgets/widgets.dart';

part 'bloc.dart';

class ExploreScreen extends StatelessWidget {
  final PageController pageController;
  final NavBarState navBarState;

  const ExploreScreen({
    super.key,
    required this.pageController,
    required this.navBarState,
  }) : super();

  @override
  Widget build(BuildContext context) => ExploreConsumer(
        listener: _handleExploreStateChanged,
        builder: (context, exploreState) => switch (exploreState) {
          LoaderLoadedState(data: final response) => switch (response) {
              AuthRes(data: final response) => switch (response) {
                  HttpResponseSuccess(data: final users) => users.isEmpty
                      ? const EmptyPage()
                      : PageView.builder(
                          controller: pageController,
                          itemBuilder: (context, page) => ExploreUserPage(
                            countdown: switch (navBarState) {
                              NavBarHoldingLogoState(
                                countdown: final countdown
                              ) =>
                                countdown,
                              _ => null,
                            },
                            user: users[page % users.length],
                          ),
                        ),
                  _ => const Loader(),
                },
              _ => const Loader(),
            },
          _ => const Loader(),
        },
      );
}
