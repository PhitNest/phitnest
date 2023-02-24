part of home_page;

extension _ExploreOnFriendRequestError on _ExploreBloc {
  void onFriendRequestError(
      _ExploreSendFriendRequestErrorEvent event, Emitter<_IExploreState> emit) {
    StyledErrorBanner.show(event.failure);
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
