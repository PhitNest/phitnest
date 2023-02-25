part of friends_page;

extension _OnRemoveFriendError on _FriendsBloc {
  void onRemoveFriendError(
    _RemoveFriendErrorEvent event,
    Emitter<_IFriendsState> emit,
  ) {
    StyledErrorBanner.show(event.failure);
    if (state is _ILoadedState) {
      final state = this.state as _ILoadedState;
      emit(state.copyWith(
          removingFriends: state.removingFriends..remove(event.friend.id)));
    }
  }
}
