part of options_page;

extension _OnError on _OptionsBloc {
  void onLoadingError(
    _ErrorEvent event,
    Emitter<_OptionsState> emit,
  ) =>
      emit(
        _LoadingErrorState(
          failure: event.failure,
          response: state.response,
        ),
      );
}
