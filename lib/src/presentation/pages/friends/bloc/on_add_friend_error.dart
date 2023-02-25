part of friends_page;

extension _OnAddFriendError on _FriendsBloc {
  void onAddFriendError(
    _AddFriendErrorEvent event,
    Emitter<_IFriendsState> emit,
  ) {
    StyledErrorBanner.show(event.failure);
    if (state is _ILoadedState) {
      final state = this.state as _ILoadedState;
      emit(state.copyWith(
          sendingRequests: state.sendingRequests..remove(event.friend.id)));
    }
  }
}
