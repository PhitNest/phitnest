part of home_page;

extension _ExploreOnFriendshipResponse on _ExploreBloc {
  void onFriendshipResponse(_ExploreFriendshipResponseEvent event,
      Emitter<_IExploreState> emit) async {
    if (state is _IExploreLoadedState) {
      final state = this.state as _IExploreLoadedState;
      if (state is _IExploreReloadingState) {
        final state = this.state as _IExploreReloadingState;
        emit(
          _ExploreMatchedReloadingState(
            explore: state.explore,
            friendship: event.friendship,
          ),
        );
      } else {
        emit(_ExploreMatchedState(friendship: event.friendship));
      }
    }
  }
}
