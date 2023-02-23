part of home_page;

extension _ExploreOnLoaded on _ExploreBloc {
  void onLoaded(_ExploreLoadedEvent event, Emitter<_IExploreState> emit) {
    int newPageIndex = 0;
    if (state is _IExploreLoadedState) {
      final state = this.state as _IExploreLoadedState;
      newPageIndex = event.response.indexWhere((user) =>
          user.id ==
          state
              .userExploreResponse[
                  state.currentPageIndex % state.userExploreResponse.length]
              .id);
      if (newPageIndex == -1) {
        newPageIndex = 0;
      }
    }
    if (state is _ExploreSendingFriendRequestState) {
      final state = this.state as _ExploreSendingFriendRequestState;
      emit(
        _ExploreSendingFriendRequestState(
          currentPageIndex: newPageIndex,
          userExploreResponse: event.response,
          sendRequest: state.sendRequest,
        ),
      );
    } else if (state is _ExploreHoldingState) {
      final state = this.state as _ExploreHoldingState;
      emit(
        _ExploreHoldingState(
          currentPageIndex: newPageIndex,
          userExploreResponse: event.response,
          countdown: state.countdown,
          incrementCountdown: state.incrementCountdown,
        ),
      );
    } else {
      emit(
        _ExploreLoadedState(
          currentPageIndex: newPageIndex,
          userExploreResponse: event.response,
        ),
      );
    }
  }
}
