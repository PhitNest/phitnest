part of login_page;

LoginBloc _bloc(BuildContext context) => context.read();

void _onPressedForgotPassword(BuildContext context) {
  _bloc(context).add(CancelLoginEvent());
  Navigator.push(
    context,
    CupertinoPageRoute(
      builder: (context) => ForgotPasswordPage(),
    ),
  );
}

void _onPressedRegister(BuildContext context) {
  _bloc(context).add(CancelLoginEvent());
  Navigator.push(
    context,
    CupertinoPageRoute(
      builder: (context) => RegistrationPage(),
    ),
  );
}

void _onPressedSubmit(BuildContext context) =>
    _bloc(context).add(SubmitEvent());

/// Handles signing in and has links to forgot password and registration
class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => BlocProvider<LoginBloc>(
        create: (context) => LoginBloc(),
        child: BlocConsumer<LoginBloc, LoginState>(
          listener: (context, state) async {
            if (state is LoginSuccessState) {
              Navigator.pushAndRemoveUntil(
                context,
                CupertinoPageRoute(
                  builder: (context) => HomePage(
                    initialAccessToken: state.response.accessToken,
                    initialRefreshToken: state.response.refreshToken,
                    initialUserData: state.response.user,
                    initialPassword: state.password,
                  ),
                ),
                (_) => false,
              );
            } else if (state is ConfirmUserState) {
              // Navigate to confirm email page to confirm registration and reset login page state
              _bloc(context).add(ResetEvent());
              final response = await Navigator.push<LoginResponse>(
                context,
                CupertinoPageRoute(
                  builder: (context) => ConfirmEmailPage(
                    email: state.email,
                    password: state.password,
                  ),
                ),
              );
              if (response != null) {
                Navigator.pushAndRemoveUntil(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => HomePage(
                      initialAccessToken: response.accessToken,
                      initialRefreshToken: response.refreshToken,
                      initialUserData: response.user,
                      initialPassword: state.password,
                    ),
                  ),
                  (_) => false,
                );
              }
            }
          },
          builder: (context, state) {
            final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
            if (state is LoginSuccessState || state is ConfirmUserState) {
              return StyledScaffold(
                body: Column(
                  children: [
                    200.verticalSpace,
                    CircularProgressIndicator(),
                  ],
                ),
              );
            } else if (state is LoadingState) {
              return LoginLoading(
                keyboardHeight: keyboardHeight,
                emailController: state.emailController,
                passwordController: state.passwordController,
                emailFocusNode: state.emailFocusNode,
                passwordFocusNode: state.passwordFocusNode,
                formKey: state.formKey,
                autovalidateMode: state.autovalidateMode,
                invalidCredentials: state.invalidCredentials,
                onSubmit: () => _onPressedSubmit(context),
                onPressedForgotPassword: () =>
                    _onPressedForgotPassword(context),
                onPressedRegister: () => _onPressedRegister(context),
              );
            } else if (state is InitialState) {
              return LoginInitial(
                autovalidateMode: state.autovalidateMode,
                emailController: state.emailController,
                emailFocusNode: state.emailFocusNode,
                formKey: state.formKey,
                passwordController: state.passwordController,
                passwordFocusNode: state.passwordFocusNode,
                keyboardHeight: keyboardHeight,
                invalidCredentials: state.invalidCredentials,
                onPressedForgotPassword: () =>
                    _onPressedForgotPassword(context),
                onPressedRegister: () => _onPressedRegister(context),
                onSubmit: () => _onPressedSubmit(context),
              );
            } else {
              throw Exception('Invalid state: $state');
            }
          },
        ),
      );
}
