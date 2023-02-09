part of forgot_password_page;

extension _OnSubmit on _ForgotPasswordBloc {
  void onSubmit(
    _SubmitEvent event,
    Emitter<_ForgotPasswordState> emit,
  ) =>
      emit(
        formKey.currentState!.validate()
            ? _LoadingState(
                autovalidateMode: state.autovalidateMode,
                forgotPassOperation: CancelableOperation.fromFuture(
                  Backend.auth.forgotPassword(emailController.text.trim()),
                )..then(
                    (failure) => add(
                      failure != null
                          ? _ErrorEvent(failure)
                          : const _SuccessEvent(),
                    ),
                  ),
              )
            : const _InitialState(
                autovalidateMode: AutovalidateMode.always,
              ),
      );
}
