part of friends_page;

extension _OnRemoveFriendSuccess on _FriendsBloc {
  void onRemoveFriendSuccess(
    _RemoveFriendSuccessEvent event,
    Emitter<_IFriendsState> emit,
  ) {
    if (state is _ILoadedState) {
      final state = this.state as _ILoadedState;
      emit(state.copyWith(
          removingFriends: state.removingFriends..remove(event.friend.id)));
    }
  }
}
