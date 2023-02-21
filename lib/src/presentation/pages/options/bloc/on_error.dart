part of options_page;

extension _OnError on _OptionsBloc {
  void onLoadingError(
    _ErrorEvent event,
    Emitter<_IOptionsState> emit,
  ) {
    StyledErrorBanner.show(event.failure);
    emit(
      _InitialState(
        response: state.response,
        getUser: CancelableOperation.fromFuture(
          withAuth(
            (accessToken) =>
                Repositories.user.getUser(accessToken: accessToken),
          ),
        )..then(
            (either) => either.fold(
              (response) => add(_LoadedUserEvent(response: response)),
              (failure) => add(_ErrorEvent(failure: failure)),
            ),
          ),
      ),
    );
  }
}
