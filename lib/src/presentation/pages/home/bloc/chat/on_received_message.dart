part of home_page;

extension _ChatOnReceivedMessage on _ChatBloc {
  void onReceivedMessage(
      _ChatReceivedMessageEvent event, Emitter<_IChatState> emit) async {
    if (state is _ChatLoadedState) {
      emit(const _ChatLoadedState());
    } else if (state is _ChatLoadingState) {
      final state = this.state as _ChatLoadingState;
      emit(
        _ChatLoadingState(
          conversations: state.conversations,
        ),
      );
    } else if (state is _ChatReloadingState) {
      final state = this.state as _ChatReloadingState;
      emit(
        _ChatReloadingState(
          conversations: state.conversations,
        ),
      );
    }
  }
}
