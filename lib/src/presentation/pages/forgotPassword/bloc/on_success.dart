part of forgot_password_page;

extension on _ForgotPasswordBloc {
  void onSuccess(
    _SuccessEvent event,
    Emitter<_ForgotPasswordState> emit,
  ) =>
      emit(
        _SuccessState(
          autovalidateMode: state.autovalidateMode,
        ),
      );
}
