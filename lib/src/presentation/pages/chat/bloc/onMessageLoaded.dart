part of chat_page;

extension _OnMessageLoaded on _ChatBloc {
  void onMessageLoaded(
    _MessagesLoadedEvent event,
    Emitter<_IChatState> emit,
  ) =>
      emit(
        _MessagesLoadedState(
          messages: event.messages,
        ),
      );
}
