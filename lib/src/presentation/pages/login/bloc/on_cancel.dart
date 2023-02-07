part of login_page;

extension _OnLogin on _LoginBloc {
  Future<void> onCancel(
    _LoginEvent event,
    Emitter<_LoginState> emit,
  ) async {
    if (state is _LoadingState) {
      final state = this.state as _LoadingState;
      await state.loginOperation.cancel();
      emit(
        _InitialState(
          autovalidateMode: state.autovalidateMode,
          invalidCredentials: state.invalidCredentials,
        ),
      );
    }
  }
}
