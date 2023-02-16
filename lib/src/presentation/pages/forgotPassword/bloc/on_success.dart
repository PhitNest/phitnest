part of forgot_password_page;

extension _OnSuccess on _ForgotPasswordBloc {
  void onSuccess(
    _SuccessEvent event,
    Emitter<_IForgotPasswordState> emit,
  ) =>
      emit(
        _SuccessState(
          autovalidateMode: state.autovalidateMode,
        ),
      );
}
