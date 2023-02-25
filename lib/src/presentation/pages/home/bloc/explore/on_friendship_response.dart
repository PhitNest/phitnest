part of home_page;

extension _ExploreOnFriendshipResponse on _ExploreBloc {
  void onFriendshipResponse(_ExploreFriendshipResponseEvent event,
      Emitter<_IExploreState> emit) async {
    if (state is _IExploreLoadedState) {
      final state = this.state as _IExploreLoadedState;
      await Cache.user.cacheUserExplore(Cache.user.userExploreResponse!
        ..removeAt(
            state.currentPageIndex % Cache.user.userExploreResponse!.length));
      if (state is _IExploreReloadingState) {
        final state = this.state as _IExploreReloadingState;
        emit(
          _ExploreMatchedReloadingState(
            currentPageIndex: state.currentPageIndex,
            explore: state.explore,
            friendship: event.friendship,
          ),
        );
      } else {
        final state = this.state as _IExploreLoadedState;
        emit(
          _ExploreMatchedState(
            currentPageIndex: state.currentPageIndex,
            friendship: event.friendship,
          ),
        );
      }
    }
  }
}
