part of friends_page;

extension _OnDenyRequestError on _FriendsBloc {
  void onDenyRequestError(
    _DenyRequestErrorEvent event,
    Emitter<_IFriendsState> emit,
  ) {
    StyledErrorBanner.show(event.failure);
    if (state is _ILoadedState) {
      final state = this.state as _ILoadedState;
      emit(state.copyWith(
          denyingRequests: state.denyingRequests..remove(event.friend.id)));
    }
  }
}
