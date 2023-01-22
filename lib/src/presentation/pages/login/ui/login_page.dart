import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../pages.dart';
import '../bloc/login_bloc.dart';
import '../event/cancel_login.dart';
import '../event/login_event.dart';
import '../event/reset.dart';
import '../state/confirm_user.dart';
import '../state/loading.dart';
import '../state/login_state.dart';
import '../state/login_success.dart';
import 'widgets/initial.dart';
import 'widgets/loading.dart';

void _onPressedForgotPassword(BuildContext context) {
  context.read<LoginBloc>().add(CancelLoginEvent());
  Navigator.push(
    context,
    CupertinoPageRoute(
      builder: (context) => ForgotPasswordPage(),
    ),
  );
}

void _onPressedRegister(BuildContext context) {
  context.read<LoginBloc>().add(CancelLoginEvent());
  Navigator.push(
    context,
    CupertinoPageRoute(
      builder: (context) => RegistrationPage(),
    ),
  );
}

void _onPressedSubmit(BuildContext context) =>
    context.read<LoginBloc>().add(SubmitEvent());

/// Handles signing in and has links to forgot password and registration
class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => BlocProvider<LoginBloc>(
        create: (context) => LoginBloc(),
        child: BlocConsumer<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state is LoginSuccessState) {
              Navigator.pushAndRemoveUntil(
                context,
                CupertinoPageRoute(
                  builder: (context) => HomePage(),
                ),
                (_) => false,
              );
            } else if (state is ConfirmUserState) {
              // Navigate to confirm email page and reset login page state
              context.read<LoginBloc>().add(ResetEvent());
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => ConfirmEmailPage(
                    email: state.email,
                  ),
                ),
              );
            }
          },
          builder: (context, state) {
            final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
            if (state is LoginSuccessState || state is ConfirmUserState) {
              return Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else if (state is LoadingState) {
              return LoginLoadingPage(
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
              return LoginInitialPage(
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
