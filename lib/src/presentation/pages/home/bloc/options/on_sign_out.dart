part of home_page;

extension _OptionsOnSignOut on _OptionsBloc {
  void onSignOut(
    _OptionsSignOutEvent event,
    Emitter<_IOptionsState> emit,
  ) async {
    if (state is _OptionsInitialState) {
      final state = this.state as _OptionsInitialState;
      await state.getUser.cancel();
    }
    emit(
      _OptionsSignOutLoadingState(
        signOut: CancelableOperation.fromFuture(
          authMethods.withAuthVoid(
            (accessToken) => Repositories.auth.signOut(
              accessToken: accessToken,
              allDevices: true,
            ),
          ),
        )..then(
            (failure) => add(const _OptionsSignOutResponseEvent()),
          ),
      ),
    );
  }
}
