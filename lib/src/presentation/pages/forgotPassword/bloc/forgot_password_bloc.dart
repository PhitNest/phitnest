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

    if (state is _ErrorState) {
      final state = this.state as _ErrorState;
      state.errorBanner.dismiss();
    }
    emailController.dispose();
    passwordController.dispose();
    confirmPassController.dispose();
    return super.close();
  }
}
