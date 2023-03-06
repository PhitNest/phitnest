import 'package:flutter/material.dart';
import 'package:phitnest_core/core.dart';

import '../change_password/change_password.dart';
import '../home/home.dart';
import 'widgets/widgets.dart';

part 'bloc.dart';

final class LoginPage extends StatelessWidget {
  final ApiInfo apiInfo;

  void handleStateChanged(
      BuildContext context, LoaderState<LoginResponse> loaderState) {
    switch (loaderState) {
      case LoaderLoadedState(data: final response):
        switch (response) {
          case LoginSuccess(session: final session):
            context.sessionLoader
                .add(LoaderSetEvent(RefreshSessionSuccess(session)));
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute<void>(
                builder: (context) => HomePage(
                  apiInfo: session.apiInfo,
                ),
              ),
              (_) => false,
            );
          case LoginChangePasswordRequired(user: final user):
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (context) => ChangePasswordPage(
                  unauthenticatedSession: UnauthenticatedSession(
                    apiInfo: apiInfo,
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

  const LoginPage({
    super.key,
    required this.apiInfo,
  }) : super();

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Container(
          margin: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.25),
          child: loginForm(
            apiInfo,
            (context, controllers, submit) => LoaderConsumer(
              listener: handleStateChanged,
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