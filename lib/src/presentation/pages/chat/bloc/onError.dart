part of chat_page;

extension on _ChatBloc {
  void onErrorCaught(
    _ErrorEvent event,
    Emitter<_ChatState> emit,
  ) =>
      emit(
        _ErrorState(
          failure: event.failure,
        ),
      );
}
