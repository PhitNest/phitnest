part of chat_page;

extension _OnError on _ChatBloc {
  void onErrorCaught(
    _ErrorEvent event,
    Emitter<_IChatState> emit,
  ) =>
      emit(
        _ErrorState(
          failure: event.failure,
        ),
      );
}
