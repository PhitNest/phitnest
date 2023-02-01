part of login_page;

extension on _LoginBloc {
  Future<void> onCancel(
    _LoginEvent event,
    Emitter<_LoginState> emit,
  ) async {
    if (state is _LoadingState) {
      final loadingState = state as _LoadingState;
      await loadingState.loginOperation.cancel();
      emit(
        _InitialState(
          autovalidateMode: state.autovalidateMode,
          invalidCredentials: state.invalidCredentials,
        ),
      );
    }
  }
}
