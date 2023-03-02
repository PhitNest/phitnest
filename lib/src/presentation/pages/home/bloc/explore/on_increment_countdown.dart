part of home_page;

extension _ExploreOnIncrementCountdown on _ExploreBloc {
  void onIncrementCountdown(
      _ExploreIncrementCountdownEvent event, Emitter<_IExploreState> emit) {
    if (state is _IExploreHoldingState) {
      final state = this.state as _IExploreHoldingState;
      final sendRequest = () {
        final user = Cache.user.userExploreResponse![
            pageController.page!.round() %
                Cache.user.userExploreResponse!.length];
        return CancelableOperation.fromFuture(
          authMethods.withAuthEither3(
            (accessToken) => Repositories.friendRequest.send(
              accessToken: accessToken,
              recipientCognitoId: user.cognitoId,
            ),
          ),
        )..then(
            (res) => add(
              res.fold(
                (request) => const _ExploreResetEvent(),
                (friendship) => _ExploreFriendshipResponseEvent(friendship),
                (failure) => _ExploreSendFriendRequestErrorEvent(failure),
              ),
            ),
          );
      };
      final incrementCountdown = () => CancelableOperation.fromFuture(
            Future.delayed(
              const Duration(seconds: 1),
              () {},
            ),
          )..then(
              (_) => add(const _ExploreIncrementCountdownEvent()),
            );
      if (state is _ExploreHoldingState) {
        final state = this.state as _ExploreHoldingState;
        emit(
          state.countdown > 1
              ? _ExploreHoldingState(
                  countdown: state.countdown - 1,
                  incrementCountdown: incrementCountdown(),
                )
              : _ExploreSendingFriendRequestState(sendRequest: sendRequest()),
        );
      } else if (state is _ExploreHoldingReloadingState) {
        final state = this.state as _ExploreHoldingReloadingState;
        emit(
          state.countdown > 1
              ? _ExploreHoldingReloadingState(
                  countdown: state.countdown - 1,
                  explore: state.explore,
                  incrementCountdown: incrementCountdown(),
                )
              : _ExploreSendingFriendRequestReloadingState(
                  explore: state.explore,
                  sendRequest: sendRequest(),
                ),
        );
      }
    }
  }
}