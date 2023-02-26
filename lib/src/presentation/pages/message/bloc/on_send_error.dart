part of message;

extension _OnSendError on _MessageBloc {
  void onSendError(_SendErrorEvent event, Emitter<_IMessageState> emit) {
    StyledErrorBanner.show(event.failure);
    emit(const _LoadedState());
  }
}
