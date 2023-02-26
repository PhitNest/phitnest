part of home_page;

extension _ExploreOnReset on _ExploreBloc {
  void onReset(_ExploreResetEvent event, Emitter<_IExploreState> emit) async {
    if (state is _IExploreSendingFriendRequestState) {
      final state = this.state as _IExploreSendingFriendRequestState;
      if (state is _ExploreSendingFriendRequestReloadingState) {
        final state = this.state as _ExploreSendingFriendRequestReloadingState;
        emit(_ExploreReloadingState(explore: state.explore));
      } else {
        emit(const _ExploreLoadedState());
      }
    } else if (state is _ExploreMatchedReloadingState) {
      final state = this.state as _ExploreMatchedReloadingState;
      emit(_ExploreReloadingState(explore: state.explore));
    } else if (state is _ExploreMatchedState) {
      emit(const _ExploreLoadedState());
    }
  }
}
