part of forgot_password_page;

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      BlocWidget<_ForgotPasswordBloc, _IForgotPasswordState>(
        create: (context) => _ForgotPasswordBloc(),
        listener: (context, state) async {
          if (state is _SuccessState) {
            return context.goToSubmitPage();
          }
          if (state is _ConfirmingEmailState) {
            final String email = context.bloc.emailController.text.trim();
            final confirmEmailResponse = await Navigator.push(
              context,
              CupertinoPageRoute<LoginResponse>(
                builder: (context) => ConfirmEmailPage(
                  email: email,
                  shouldLogin: false,
                  password: Cache.auth.password,
                ),
              ),
            );
            if (confirmEmailResponse != null) {
              return context.goToSubmitPage();
            }
          }
        },
        builder: (context, state) {
          if (state is _LoadingState) {
            return _LoadingPage(
              emailController: context.bloc.emailController,
              passwordController: context.bloc.passwordController,
              confirmPassController: context.bloc.confirmPassController,
              autovalidateMode: state.autovalidateMode,
              formKey: context.bloc.formKey,
            );
          } else {
            return _InitialPage(
              emailController: context.bloc.emailController,
              passwordController: context.bloc.passwordController,
              confirmPassController: context.bloc.confirmPassController,
              autovalidateMode: state.autovalidateMode,
              formKey: context.bloc.formKey,
              onSubmit: context.onPressedSubmit,
            );
          }
        },
      );
}
