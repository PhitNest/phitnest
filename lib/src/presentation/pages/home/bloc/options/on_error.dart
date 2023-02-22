part of home_page;

extension _OptionsOnError on _OptionsBloc {
  void onLoadingError(
    _OptionsErrorEvent event,
    Emitter<_IOptionsState> emit,
  ) {
    StyledErrorBanner.show(event.failure);
    emit(
      _OptionsInitialState(
        response: state.response,
        getUser: CancelableOperation.fromFuture(
          withAuth(
            (accessToken) =>
                Repositories.user.getUser(accessToken: accessToken),
          ),
        )..then(
            (either) => either.fold(
              (response) => add(_OptionsLoadedUserEvent(response: response)),
              (failure) => add(_OptionsErrorEvent(failure: failure)),
            ),
          ),
      ),
    );
  }
}
