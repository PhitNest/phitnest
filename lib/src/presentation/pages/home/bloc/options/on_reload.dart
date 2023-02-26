part of home_page;

extension _OptionsOnReload on _OptionsBloc {
  void onReload(
    _OptionsReloadEvent event,
    Emitter<_IOptionsState> emit,
  ) =>
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
