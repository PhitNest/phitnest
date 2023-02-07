part of options_page;

extension _OnSignOut on _OptionsBloc {
  void onSignOut(
    _SignOutEvent event,
    Emitter<_OptionsState> emit,
  ) =>
      emit(
        _SignOutLoadingState(
          signOut: CancelableOperation.fromFuture(
            withAuth(
              (accessToken) => Repositories.auth.signOut(
                accessToken: accessToken,
                allDevices: true,
              ),
            ),
          )..then(
              (failure) => add(
                failure != null
                    ? _SignOutErrorEvent(failure)
                    : const _SignOutSuccessEvent(),
              ),
            ),
        ),
      );
}
