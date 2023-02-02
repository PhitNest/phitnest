part of login_page;

extension on BuildContext {
  _LoginBloc get bloc => read();

  void submit() => bloc.add(const _SubmitEvent());

  void goToForgotPassword() {
    bloc.add(const _CancelEvent());
    Navigator.push(
      this,
      CupertinoPageRoute(
        builder: (context) => const ForgotPasswordPage(),
      ),
    );
  }

  void goToRegistration() {
    bloc.add(const _CancelEvent());
    Navigator.push(
      this,
      CupertinoPageRoute(
        builder: (context) => const RegistrationPage(),
      ),
    );
  }
}

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (context) => _LoginBloc(),
        child: BlocConsumer<_LoginBloc, _LoginState>(
          listener: (context, state) {
            if (state is _SuccessState) {
              Navigator.pushAndRemoveUntil(
                context,
                CupertinoPageRoute(
                  builder: (context) => HomePage(
                    initialData: state.response,
                    initialPassword: context.bloc.passwordController.text,
                  ),
                ),
                (_) => false,
              );
            } else if (state is _ConfirmingEmailState) {
              Navigator.push<LoginResponse>(
                context,
                CupertinoPageRoute(
                  builder: (context) => ConfirmEmailPage(
                    email: state.email,
                    password: state.password,
                  ),
                ),
              ).then(
                (response) {
                  if (response != null) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => HomePage(
                          initialData: response,
                          initialPassword: state.password,
                        ),
                      ),
                      (_) => false,
                    );
                  }
                },
              );
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
        ),
      );
}
