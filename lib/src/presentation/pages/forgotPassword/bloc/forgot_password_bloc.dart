part of forgot_password_page;

class _ForgotPasswordBloc
    extends Bloc<_IForgotPasswordEvent, _IForgotPasswordState> {
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
      final state = this.state as _LoadingState;
      await state.forgotPassOperation.cancel();
    }
    emailController.dispose();
    passwordController.dispose();
    confirmPassController.dispose();
    return super.close();
  }
}

extension _Bloc on BuildContext {
  _ForgotPasswordBloc get bloc => read();

  Future<void> goToSubmitPage() {
    final email = bloc.emailController.text.trim();
    final password = bloc.passwordController.text;
    return Navigator.push<LoginResponse>(
      this,
      CupertinoPageRoute(
        builder: (context) => ForgotPasswordSubmitPage(
          email: email,
          password: password,
        ),
      ),
    ).then(
      (submitResult) {
        if (submitResult != null) {
          return Navigator.pushAndRemoveUntil(
            this,
            CupertinoPageRoute(
              builder: (context) => HomePage(),
            ),
            (_) => false,
          );
        }
      },
    );
  }

  void onPressedSubmit() => bloc.add(const _SubmitEvent());
}
