part of login_page;

void onReset(
  ResetEvent event,
  Emitter<LoginState> emit,
  LoginState state,
) {
  if (state is ConfirmUserState) {
    emit(
      InitialState(
        emailController: TextEditingController(text: state.email),
        passwordController: TextEditingController(),
        emailFocusNode: FocusNode(),
        passwordFocusNode: FocusNode(),
        formKey: GlobalKey(),
        autovalidateMode: AutovalidateMode.disabled,
        invalidCredentials: {},
      ),
    );
  } else {
    throw Exception('Invalid state: $state');
  }
}
