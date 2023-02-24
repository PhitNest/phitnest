part of home_page;

extension _ExploreOnLoadingError on _ExploreBloc {
  void onLoadingError(
      _ExploreLoadingErrorEvent event, Emitter<_IExploreState> emit) {
    StyledErrorBanner.show(event.failure);
    final explore = CancelableOperation.fromFuture(
      withAuth(
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
          currentPageIndex: state.currentPageIndex,
          sendRequest: state.sendRequest,
          explore: explore,
        ),
      );
    } else if (state is _ExploreMatchedReloadingState) {
      final state = this.state as _ExploreMatchedReloadingState;
      emit(
        _ExploreMatchedReloadingState(
          currentPageIndex: state.currentPageIndex,
          friendship: state.friendship,
          explore: explore,
        ),
      );
    } else if (state is _ExploreHoldingReloadingState) {
      final state = this.state as _ExploreHoldingReloadingState;
      emit(
        _ExploreHoldingReloadingState(
          currentPageIndex: state.currentPageIndex,
          explore: explore,
          countdown: state.countdown,
          incrementCountdown: state.incrementCountdown,
        ),
      );
    } else if (state is _ExploreReloadingState) {
      final state = this.state as _ExploreReloadingState;
      emit(
        _ExploreReloadingState(
          currentPageIndex: state.currentPageIndex,
          explore: explore,
        ),
      );
    } else {
      emit(
        _ExploreLoadingState(
          explore: explore,
        ),
      );
    }
  }
}
