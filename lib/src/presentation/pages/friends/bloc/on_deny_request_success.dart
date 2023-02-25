part of friends_page;

extension _OnDenyRequestSuccess on _FriendsBloc {
  void onDenyRequestSuccess(
    _DenyRequestSuccessEvent event,
    Emitter<_IFriendsState> emit,
  ) {
    if (state is _ILoadedState) {
      final state = this.state as _ILoadedState;
      emit(state.copyWith(
          denyingRequests: state.denyingRequests..remove(event.friend.id)));
    }
  }
}
