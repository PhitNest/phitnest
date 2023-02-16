part of options_page;

extension _OnLoaded on _OptionsBloc {
  void onLoaded(
    _LoadedUserEvent event,
    Emitter<_IOptionsState> emit,
  ) =>
      emit(
        _LoadedUserState(
          response: event.response,
        ),
      );
}
