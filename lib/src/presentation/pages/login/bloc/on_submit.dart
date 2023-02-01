part of login_page;

void onSubmit(
  SubmitEvent event,
  Emitter<LoginState> emit,
  LoginState state,
  ValueChanged<LoginEvent> add,
) {
  if (state is InitialState) {
    if (state.formKey.currentState!.validate()) {
      emit(
        LoadingState(
          autovalidateMode: state.autovalidateMode,
          invalidCredentials: state.invalidCredentials,
          emailController: state.emailController,
          passwordController: state.passwordController,
          emailFocusNode: state.emailFocusNode,
          passwordFocusNode: state.passwordFocusNode,
          formKey: state.formKey,
          loginOperation: CancelableOperation.fromFuture(
            Repositories.auth.login(
              email: state.emailController.text.trim(),
              password: state.passwordController.text,
            ),
          )..then(
              (res) => res.fold(
                (res) => add(LoginSuccessEvent(res)),
                (failure) => add(
                  LoginErrorEvent(
                    failure,
                    state.emailController.text.trim(),
                    state.passwordController.text,
                  ),
                ),
              ),
            ),
        ),
      );
    } else {
      emit(
        InitialState(
          emailController: state.emailController,
          passwordController: state.passwordController,
          emailFocusNode: state.emailFocusNode,
          passwordFocusNode: state.passwordFocusNode,
          formKey: state.formKey,
          autovalidateMode: AutovalidateMode.always,
          invalidCredentials: state.invalidCredentials,
        ),
      );
    }
  } else {
    throw Exception('Invalid state: $state');
  }
}
