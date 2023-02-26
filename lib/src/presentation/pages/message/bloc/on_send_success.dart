part of message;

extension _OnSendSuccess on _MessageBloc {
  void onSendSuccess(_SendSuccessEvent event, Emitter<_IMessageState> emit) {
    emit(const _LoadedState());
  }
}
