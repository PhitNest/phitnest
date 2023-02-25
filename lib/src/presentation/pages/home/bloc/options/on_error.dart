part of home_page;

extension _OptionsOnError on _OptionsBloc {
  void onLoadingError(
    _OptionsErrorEvent event,
    Emitter<_IOptionsState> emit,
  ) {
    StyledErrorBanner.show(event.failure);
    emit(
      _OptionsInitialState(
        getUser: CancelableOperation.fromFuture(
          authMethods.withAuth(
            (accessToken) =>
                Repositories.user.getUser(accessToken: accessToken),
          ),
        )..then(
            (either) => add(
              either.fold(
                (response) => const _OptionsLoadedUserEvent(),
                (failure) => _OptionsErrorEvent(failure: failure),
              ),
            ),
          ),
      ),
    );
  }
}
