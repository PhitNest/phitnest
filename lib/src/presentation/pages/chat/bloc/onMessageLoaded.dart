part of chat_page;

extension on _ChatBloc {
  void onMessageLoaded(
    _MessagesLoadedEvent event,
    Emitter<_ChatState> emit,
  ) =>
      emit(
        _MessagesLoadedState(
          messages: event.messages,
        ),
      );
}
