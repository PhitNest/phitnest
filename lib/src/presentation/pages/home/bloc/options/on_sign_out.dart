part of home_page;

extension _OptionsOnSignOut on _OptionsBloc {
  void onSignOut(
    _OptionsSignOutEvent event,
    Emitter<_IOptionsState> emit,
  ) async {
    final signOut = CancelableOperation.fromFuture(
      authMethods.withAuthVoid(
        (accessToken) => Repositories.auth.signOut(
          accessToken: accessToken,
          allDevices: true,
        ),
      ),
    )..then(
        (failure) => add(const _OptionsSignOutResponseEvent()),
      );
    if (state is _OptionsInitialState) {
      final state = this.state as _OptionsInitialState;
      await state.getUser.cancel();
      emit(
        _OptionsSignOutLoadingState(
          response: state.response,
          signOut: signOut,
        ),
      );
    } else {
      emit(
        _OptionsSignOutLoadingState(
          response: state.response,
          signOut: signOut,
        ),
      );
    }
  }
}
