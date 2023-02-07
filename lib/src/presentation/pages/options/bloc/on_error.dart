part of options_page;

extension _OnError on _OptionsBloc {
  void onErrorCaught(
    _ErrorEvent event,
    Emitter<_OptionsState> emit,
  ) =>
      emit(
        _ErrorState(
          failure: event.failure,
        ),
      );
}
