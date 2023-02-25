part of message;

extension _OnLoaded on _MessageBloc {
  void onLoaded(_LoadedEvent event, Emitter<_IMessageState> emit) =>
      emit(const _LoadedState());
}
