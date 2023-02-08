part of options_page;

extension _OnLoaded on _OptionsBloc {
  void onLoaded(
    _LoadedUserEvent event,
    Emitter<_OptionsState> emit,
  ) =>
      emit(
        _LoadedUserState(
          response: event.response,
        ),
      );
}
