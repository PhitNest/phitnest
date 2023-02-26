part of home_page;

extension _ExploreOnLoadingError on _ExploreBloc {
  void onLoadingError(
      _ExploreLoadingErrorEvent event, Emitter<_IExploreState> emit) {
    StyledErrorBanner.show(event.failure);
    final explore = CancelableOperation.fromFuture(
      authMethods.withAuth(
        (accessToken) => Repositories.user.exploreUsers(
          accessToken: accessToken,
          gymId: Cache.gym.gym!.id,
        ),
      ),
    )..then(
        (either) => add(
          either.fold(
            (response) => const _ExploreLoadedEvent(),
            (failure) => _ExploreLoadingErrorEvent(failure),
          ),
        ),
      );
    if (state is _ExploreSendingFriendRequestReloadingState) {
      final state = this.state as _ExploreSendingFriendRequestReloadingState;
      emit(
        _ExploreSendingFriendRequestReloadingState(
          sendRequest: state.sendRequest,
          explore: explore,
        ),
      );
    } else if (state is _ExploreMatchedReloadingState) {
      final state = this.state as _ExploreMatchedReloadingState;
      emit(
        _ExploreMatchedReloadingState(
          friendship: state.friendship,
          explore: explore,
        ),
      );
    } else if (state is _ExploreHoldingReloadingState) {
      final state = this.state as _ExploreHoldingReloadingState;
      emit(
        _ExploreHoldingReloadingState(
          explore: explore,
          countdown: state.countdown,
          incrementCountdown: state.incrementCountdown,
        ),
      );
    } else if (state is _ExploreReloadingState) {
      emit(_ExploreReloadingState(explore: explore));
    } else {
      emit(_ExploreLoadingState(explore: explore));
    }
  }
}
