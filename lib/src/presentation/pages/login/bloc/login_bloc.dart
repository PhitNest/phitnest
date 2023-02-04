part of login_page;

class _LoginBloc extends Bloc<_LoginEvent, _LoginState> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  _LoginBloc()
      : super(
          _InitialState(
            autovalidateMode: AutovalidateMode.disabled,
            invalidCredentials: {},
          ),
        ) {
    on<_SubmitEvent>(onSubmit);
    on<_SuccessEvent>(onSuccess);
    on<_ErrorEvent>(onLoginError);
    on<_CancelEvent>(onCancel);
  }

  @override
  Future<void> close() {
    if (state is _LoadingState) {
      final state = this.state as _LoadingState;
      state.loginOperation.cancel();
    }
    emailController.dispose();
    passwordController.dispose();
    return super.close();
  }
}
