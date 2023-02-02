part of login_page;

extension on _LoginBloc {
  void onSubmit(
    _SubmitEvent event,
    Emitter<_LoginState> emit,
  ) =>
      emit(
        formKey.currentState!.validate()
            ? _LoadingState(
                autovalidateMode: state.autovalidateMode,
                invalidCredentials: state.invalidCredentials,
                loginOperation: CancelableOperation.fromFuture(
                  Repositories.auth.login(
                    email: emailController.text.trim(),
                    password: passwordController.text,
                  ),
                )..then(
                    (res) => res.fold(
                      (res) => add(_SuccessEvent(res)),
                      (failure) => add(_ErrorEvent(failure)),
                    ),
                  ),
              )
            : _InitialState(
                autovalidateMode: AutovalidateMode.always,
                invalidCredentials: state.invalidCredentials,
              ),
      );
}
