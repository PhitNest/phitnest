part of home_page;

extension _ExploreOnFriendRequestResponse on _ExploreBloc {
  void onFriendRequestResponse(
      _ExploreFriendRequestResponseEvent event, Emitter<_IExploreState> emit) {
    if (state is _IExploreSendingFriendRequestState) {
      final state = this.state as _IExploreSendingFriendRequestState;
      Cache.user.userExploreResponse!.removeAt(
          state.currentPageIndex % Cache.user.userExploreResponse!.length);
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
    }
  }
}
