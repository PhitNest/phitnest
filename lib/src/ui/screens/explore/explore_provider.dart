import 'package:flutter/material.dart';
import 'package:phitnest_mobile/src/entities/entities.dart';

import '../../../use-cases/use_cases.dart';
import '../../widgets/widgets.dart';
import '../screen_provider.dart';
import '../screens.dart';
import 'explore_state.dart';
import 'explore_view.dart';

class ExploreProvider extends ScreenProvider<ExploreCubit, ExploreState> {
  final navbarKey = GlobalKey();

  ExploreProvider() : super();

  @override
  Future<void> listener(
    BuildContext context,
    ExploreCubit cubit,
    ExploreState state,
  ) async {
    if (state is HoldingState) {
      if (state.countdown == 0) {
        final user = state.users[state.pageIndex % state.users.length];
        cubit.removeUser(state.pageIndex);
        cubit.transitionStopHolding();
        sendFriendRequestUseCase.sendFriendRequest(user.cognitoId).then(
          (failure) {
            if (failure != null) {
              cubit.transitionToError(failure.message);
            } else {
              final requestIndex = state.incomingRequests.indexWhere(
                (request) => request.cognitoId == user.cognitoId,
              );
              if (requestIndex != -1) {
                cubit.removeRequest(requestIndex);
                Navigator.push(
                  context,
                  NoAnimationMaterialPageRoute(
                    builder: (context) => MatchProvider(user),
                  ),
                );
              }
            }
          },
        );
      }
    } else if (state is LoadingState) {
      Future.wait([
        exploreUseCase.exploreUsers(),
        getFriendRequestsUseCase.getIncomingFriendRequests(),
      ]).then(
        (eithers) => eithers[0].fold(
          (users) => eithers[1].fold(
            (requests) => cubit.transitionToLoaded(
              users,
              requests as List<PublicUserEntity>,
              0,
            ),
            (failure) => cubit.transitionToError(failure.message),
          ),
          (failure) => cubit.transitionToError(failure.message),
        ),
      );
    } else if (state is LoadedState) {
      if (state.users.isEmpty) {
        cubit.transitionToEmpty();
      }
    }
  }

  @override
  Widget builder(
    BuildContext context,
    ExploreCubit cubit,
    ExploreState state,
  ) {
    if (state is LoadingState) {
      return LoadingView(navbarKey: navbarKey);
    } else if (state is ErrorState) {
      return ErrorView(
        navbarKey: navbarKey,
        errorMessage: state.message,
        onPressedRetry: () => cubit.transitionToLoading(),
      );
    } else if (state is LoadedState) {
      return LoadedView(
        navbarKey: navbarKey,
        users: state.users,
        onChangePage: (index) => cubit.setPageIndex(index),
        onPressedLogo: () => cubit.transitionToHolding(),
      );
    } else if (state is HoldingState) {
      return HoldingView(
        navbarKey: navbarKey,
        countdown: state.countdown,
        onReleaseLogo: () => cubit.transitionStopHolding(),
        users: state.users,
        onChangePage: (index) => cubit.setPageIndex(index),
      );
    } else if (state is EmptyNestState) {
      return EmptyNestView(
        navbarKey: navbarKey,
      );
    } else {
      throw Exception('Unknown state: $state');
    }
  }

  @override
  ExploreCubit buildCubit() => ExploreCubit();
}
