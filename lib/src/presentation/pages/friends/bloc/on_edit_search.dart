part of friends_page;

extension _OnEditSearch on _FriendsBloc {
  void onEditSearch(_EditSearchEvent event, Emitter<_IFriendsState> emit) {
    if (state is _LoadedState) {
      final state = this.state as _LoadedState;
      emit(
        _LoadedState(
          sendingRequests: state.sendingRequests,
          denyingRequests: state.denyingRequests,
          removingFriends: state.removingFriends,
        ),
      );
    } else if (state is _ReloadingState) {
      final state = this.state as _ReloadingState;
      emit(
        _ReloadingState(
          sendingRequests: state.sendingRequests,
          denyingRequests: state.denyingRequests,
          removingFriends: state.removingFriends,
          friendsAndRequests: state.friendsAndRequests,
        ),
      );
    }
  }
}
