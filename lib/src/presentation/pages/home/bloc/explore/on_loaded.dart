part of home_page;

extension _ExploreOnLoaded on _ExploreBloc {
  void onLoaded(_ExploreLoadedEvent event, Emitter<_IExploreState> emit) {
    if (state is _ExploreMatchedReloadingState) {
      final state = this.state as _ExploreMatchedReloadingState;
      emit(_ExploreMatchedState(friendship: state.friendship));
    } else if (state is _ExploreSendingFriendRequestReloadingState) {
      final state = this.state as _ExploreSendingFriendRequestReloadingState;
      emit(_ExploreSendingFriendRequestState(sendRequest: state.sendRequest));
    } else if (state is _ExploreHoldingReloadingState) {
      final state = this.state as _ExploreHoldingReloadingState;
      emit(
        _ExploreHoldingState(
          countdown: state.countdown,
          incrementCountdown: state.incrementCountdown,
        ),
      );
    } else {
      emit(const _ExploreLoadedState());
    }
  }
}
