part of forgot_password_page;

extension on _ForgotPasswordBloc {
  void onSubmit(
    _SubmitEvent event,
    Emitter<_ForgotPasswordState> emit,
  ) {
    if (formKey.currentState!.validate()) {
      emit(
        _LoadingState(
          autovalidateMode: state.autovalidateMode,
          forgotPassOperation: CancelableOperation.fromFuture(
            Backend.auth.forgotPassword(email: emailController.text.trim()),
          )..then(
              (failure) => add(
                failure != null ? _ErrorEvent(failure) : const _SuccessEvent(),
              ),
            ),
        ),
      );
    } else {
      emit(
        _InitialState(
          autovalidateMode: AutovalidateMode.always,
        ),
      );
    }
  }
}
