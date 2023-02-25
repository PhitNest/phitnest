part of home_page;

extension _ExploreOnReset on _ExploreBloc {
  void onReset(_ExploreResetEvent event, Emitter<_IExploreState> emit) async {
    if (state is _IExploreSendingFriendRequestState) {
      final state = this.state as _IExploreSendingFriendRequestState;
      await Cache.user.cacheUserExplore(Cache.user.userExploreResponse!
        ..removeAt(
            state.currentPageIndex % Cache.user.userExploreResponse!.length));
      if (state is _ExploreSendingFriendRequestReloadingState) {
        final state = this.state as _ExploreSendingFriendRequestReloadingState;
        emit(
          _ExploreReloadingState(
            currentPageIndex: state.currentPageIndex,
            explore: state.explore,
          ),
        );
      } else {
        final state = this.state as _IExploreLoadedState;
        emit(
          _ExploreLoadedState(
            currentPageIndex: state.currentPageIndex,
          ),
        );
      }
    } else if (state is _ExploreMatchedReloadingState) {
      final state = this.state as _ExploreMatchedReloadingState;
      emit(
        _ExploreReloadingState(
          currentPageIndex: state.currentPageIndex,
          explore: state.explore,
        ),
      );
    } else if (state is _ExploreMatchedState) {
      final state = this.state as _ExploreMatchedState;
      emit(
        _ExploreLoadedState(
          currentPageIndex: state.currentPageIndex,
        ),
      );
    }
  }
}
