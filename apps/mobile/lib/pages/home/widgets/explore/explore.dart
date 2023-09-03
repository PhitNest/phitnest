import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:ui/ui.dart';

import '../../../../entities/entities.dart';
import '../../home.dart';
import '../navbar/navbar.dart';
import 'widgets/widgets.dart';

void _handleExploreStateChanged(
  BuildContext context,
  LoaderState<AuthResOrLost<HttpResponse<List<UserExplore>>>> loaderState,
) {
  switch (loaderState) {
    case LoaderLoadedState(data: final response):
      switch (response) {
        case AuthRes(data: final response):
          switch (response) {
            case HttpResponseFailure(failure: final failure):
              StyledBanner.show(
                message: failure.message,
                error: true,
              );
            default:
          }
        default:
      }
    default:
  }
}

class ExploreScreen extends StatelessWidget {
  final PageController pageController;
  final HomeState homeState;
  final NavBarState navBarState;

  const ExploreScreen({
    super.key,
    required this.pageController,
    required this.homeState,
    required this.navBarState,
  }) : super();

  @override
  Widget build(BuildContext context) => ExploreConsumer(
        listener: _handleExploreStateChanged,
        builder: (context, exploreState) => switch (homeState) {
          HomeLoadingState() => const Loader(),
          HomeLoadedState(exploreUsers: final users) => users.isEmpty
              ? const EmptyPage()
              : PageView.builder(
                  controller: pageController,
                  itemBuilder: (context, page) => ExploreUserPage(
                    countdown: switch (navBarState) {
                      NavBarHoldingLogoState(countdown: final countdown) =>
                        countdown,
                      _ => null,
                    },
                    user: users[page % users.length],
                  ),
                ),
        },
      );
}
