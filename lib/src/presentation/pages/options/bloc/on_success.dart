part of options_page;

extension on _OptionsBloc {
  void onSuccess(
    _SuccessEvent event,
    Emitter<_OptionsState> emit,
  ) =>
      emit(_SuccessState());
}
