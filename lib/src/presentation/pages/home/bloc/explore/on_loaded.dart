part of home_page;

extension _ExploreOnLoaded on _ExploreBloc {
  void onLoaded(_ExploreLoadedEvent event, Emitter<_IExploreState> emit) {
    int newPageIndex = 0;
    if (state is _IExploreLoadedState) {
      final state = this.state as _IExploreLoadedState;
      newPageIndex = Cache.user.userExploreResponse!.indexWhere((user) =>
          user.id ==
          Cache
              .user
              .userExploreResponse![state.currentPageIndex %
                  Cache.user.userExploreResponse!.length]
              .id);
      if (newPageIndex == -1) {
        newPageIndex = 0;
      }
    }
    if (state is _ExploreMatchedReloadingState) {
      final state = this.state as _ExploreMatchedReloadingState;
      emit(
        _ExploreMatchedState(
          currentPageIndex: newPageIndex,
          friendship: state.friendship,
        ),
      );
    } else if (state is _ExploreSendingFriendRequestReloadingState) {
      final state = this.state as _ExploreSendingFriendRequestReloadingState;
      emit(
        _ExploreSendingFriendRequestState(
          currentPageIndex: newPageIndex,
          sendRequest: state.sendRequest,
        ),
      );
    } else if (state is _ExploreHoldingReloadingState) {
      final state = this.state as _ExploreHoldingReloadingState;
      emit(
        _ExploreHoldingState(
          currentPageIndex: newPageIndex,
          countdown: state.countdown,
          incrementCountdown: state.incrementCountdown,
        ),
      );
    } else {
      emit(
        _ExploreLoadedState(
          currentPageIndex: newPageIndex,
        ),
      );
    }
  }
}
