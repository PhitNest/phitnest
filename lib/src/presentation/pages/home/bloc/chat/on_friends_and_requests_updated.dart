part of home_page;

extension _ChatOnFriendsAndRequestsUpdated on _ChatBloc {
  void onFriendsAndRequestsUpdated(
      _ChatFriendsAndRequestsUpdatedEvent event, Emitter<_IChatState> emit) {
    if (state is _ChatLoadedState) {
      emit(_ChatLoadedState());
    } else if (state is _ChatLoadingState) {
      final state = this.state as _ChatLoadingState;
      emit(_ChatLoadingState(conversations: state.conversations));
    } else if (state is _ChatReloadingState) {
      final state = this.state as _ChatReloadingState;
      emit(_ChatReloadingState(conversations: state.conversations));
    }
  }
}
