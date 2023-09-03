import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:ui/ui.dart';

import '../change_password/change_password.dart';
import '../home/home.dart';
import 'widgets/widgets.dart';

part 'bloc.dart';

void _handleStateChanged(
  BuildContext context,
  LoaderState<LoginResponse> loaderState,
) {
  switch (loaderState) {
    case LoaderLoadedState(data: final response):
      switch (response) {
        case LoginSuccess(session: final session):
          context.sessionLoader
              .add(LoaderSetEvent(RefreshSessionSuccess(session)));
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute<void>(
              builder: (_) => const HomePage(),
            ),
            (_) => false,
          );
        case LoginChangePasswordRequired(user: final user):
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (context) => ChangePasswordPage(
                unauthenticatedSession: UnauthenticatedSession(
                  user: user,
                ),
              ),
            ),
          );
        case LoginFailureResponse(message: final message):
          StyledBanner.show(
            message: message,
            error: true,
          );
      }
    default:
  }
}

final class LoginPage extends StatelessWidget {
  const LoginPage({super.key}) : super();

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Container(
          margin: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.25),
          child: loginForm(
            (context, controllers, submit) => LoaderConsumer(
              listener: _handleStateChanged,
              builder: (context, loaderState) {
                void submitForm() => submit(
                      LoginParams(
                        email: controllers.emailController.text,
                        password: controllers.passwordController.text,
                      ),
                      loaderState,
                    );
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'PhitNest Admin Login',
                      style: Theme.of(context).textTheme.headlineLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    StyledUnderlinedTextField(
                      hint: 'Email',
                      controller: controllers.emailController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      validator: EmailValidator.validateEmail,
                    ),
                    StyledPasswordField(
                      hint: 'Password',
                      controller: controllers.passwordController,
                      textInputAction: TextInputAction.done,
                      validator: validatePassword,
                      onFieldSubmitted: (_) => submitForm(),
                    ),
                    switch (loaderState) {
                      LoaderLoadingState() => const CircularProgressIndicator(),
                      _ => LoginButton(onSubmit: submitForm),
                    },
                  ],
                );
              },
            ),
          ),
        ),
      );
}
