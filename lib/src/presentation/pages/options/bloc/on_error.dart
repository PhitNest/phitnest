part of options_page;

extension on _OptionsBloc {
  void onOptionsError(
    _ErrorEvent event,
    Emitter<_OptionsState> emit,
  ) =>
      emit(_ErrorState(failure: event.failure));
}
