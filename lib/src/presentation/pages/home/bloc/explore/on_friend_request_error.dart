part of home_page;

extension _ExploreOnFriendRequestError on _ExploreBloc {
  void onFriendRequestError(
      _ExploreSendFriendRequestErrorEvent event, Emitter<_IExploreState> emit) {
    StyledErrorBanner.show(event.failure);
    if (state is _ExploreSendingFriendRequestReloadingState) {
      final state = this.state as _ExploreSendingFriendRequestReloadingState;
      emit(_ExploreReloadingState(explore: state.explore));
    } else {
      emit(const _ExploreLoadedState());
    }
  }
}
