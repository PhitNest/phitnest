part of message;

extension _OnSend on _MessageBloc {
  void onSend(_SendEvent event, Emitter<_IMessageState> emit) {
    if (!(state is _ILoadingState)) {
      emit(
        _SendingState(
          sending: CancelableOperation.fromFuture(
            Future.delayed(
              Duration(seconds: 1),
            ),
          ),
        ),
      );
    }
  }
}
