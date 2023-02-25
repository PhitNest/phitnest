part of friends_page;

extension _OnAddFriendSuccess on _FriendsBloc {
  void onAddFriendSuccess(
    _AddFriendSuccessEvent event,
    Emitter<_IFriendsState> emit,
  ) {
    if (state is _ILoadedState) {
      final state = this.state as _ILoadedState;
      emit(state.copyWith(
          sendingRequests: state.sendingRequests..remove(event.friend.id)));
    }
  }
}
