part of forgot_password_page;

class _ForgotPasswordBloc
    extends Bloc<_ForgotPasswordEvent, _ForgotPasswordState> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPassController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  _ForgotPasswordBloc()
      : super(
          const _InitialState(
            autovalidateMode: AutovalidateMode.disabled,
          ),
        ) {
    on<_SubmitEvent>(onSubmit);
    on<_SuccessEvent>(onSuccess);
    on<_ErrorEvent>(onForgotPasswordError);
  }

  @override
  Future<void> close() async {
    if (state is _LoadingState) {
      final loadingState = state as _LoadingState;
      await loadingState.forgotPassOperation.cancel();
    }
    emailController.dispose();
    passwordController.dispose();
    confirmPassController.dispose();
    return super.close();
  }
}
