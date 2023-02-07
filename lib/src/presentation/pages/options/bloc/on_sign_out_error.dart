part of options_page;

extension _OnSignOutError on _OptionsBloc {
  void onSignOutError(
    _SignOutErrorEvent event,
    Emitter<_OptionsState> emit,
  ) =>
      emit(
        _ErrorState(
          failure: event.failure,
        ),
      );
}
