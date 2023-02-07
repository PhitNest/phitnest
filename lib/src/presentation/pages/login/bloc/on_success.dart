part of login_page;

extension _OnSuccess on _LoginBloc {
  void onSuccess(
    _SuccessEvent event,
    Emitter<_LoginState> emit,
  ) =>
      emit(
        _SuccessState(
          response: event.response,
          autovalidateMode: state.autovalidateMode,
          invalidCredentials: state.invalidCredentials,
        ),
      );
}
