part of options_page;

extension _OnError on _OptionsBloc {
  void onLoadingError(
    _ErrorEvent event,
    Emitter<_IOptionsState> emit,
  ) =>
      emit(
        _LoadingErrorState(
          response: state.response,
          errorBanner: StyledErrorBanner(
            failure: event.failure,
          ),
        ),
      );
}
