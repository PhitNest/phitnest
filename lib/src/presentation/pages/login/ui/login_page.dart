part of login_page;

class LoginPage extends StatelessWidget {
  /// **POP RESULT: NONE**
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => BlocWidget<_LoginBloc, _ILoginState>(
        create: (context) => _LoginBloc(),
        listener: (context, state) {
          // Replace widget stack with HomePage if login was successful.
          if (state is _SuccessState) {
            Navigator.pushAndRemoveUntil(
              context,
              CupertinoPageRoute(
                builder: (context) => HomePage(),
              ),
              (_) => false,
            );
          }
          // Push ConfirmEmailPage if login request results in userNotConfirmed.
          else if (state is _ConfirmingEmailState) {
            Navigator.push<LoginResponse>(
              context,
              CupertinoPageRoute(
                builder: (context) => ConfirmEmailPage(
                  email: state.email,
                  password: state.password,
                ),
              ),
            )
                // Navigate to HomePage if login request was successful.
                .then(
              (response) {
                if (response != null) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => HomePage(),
                    ),
                    (_) => false,
                  );
                }
              },
            );
          }
          // Show error banner if state is error state.
          else if (state is _ErrorState) {
            StyledErrorBanner.show(context, state.failure, state.dismiss);
          }
        },
        builder: (context, state) {
          final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
          if (state is _LoadingState) {
            return _LoadingPage(
              keyboardHeight: keyboardHeight,
              emailController: context.bloc.emailController,
              passwordController: context.bloc.passwordController,
              formKey: context.bloc.formKey,
              autovalidateMode: state.autovalidateMode,
              invalidCredentials: state.invalidCredentials,
              onPressedForgotPassword: context.goToForgotPassword,
              onPressedRegister: context.goToRegistration,
            );
          } else {
            return _InitialPage(
              autovalidateMode: state.autovalidateMode,
              emailController: context.bloc.emailController,
              formKey: context.bloc.formKey,
              passwordController: context.bloc.passwordController,
              keyboardHeight: keyboardHeight,
              invalidCredentials: state.invalidCredentials,
              onPressedForgotPassword: context.goToForgotPassword,
              onPressedRegister: context.goToRegistration,
              onSubmit: context.submit,
            );
          }
        },
      );
}
