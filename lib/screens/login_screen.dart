import 'package:flutter/material.dart';
import 'package:phitnest_core/core.dart';

import 'change_password.dart';
import 'home_screen.dart';

final class LoginControllers extends FormControllers {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
  }
}

final class LoginButton extends StatelessWidget {
  final void Function() onSubmit;

  const LoginButton({
    super.key,
    required this.onSubmit,
  }) : super();

  @override
  Widget build(BuildContext context) => MaterialButton(
        onPressed: onSubmit,
        color: Colors.black,
        textColor: Colors.white,
        child: const Text(
          'Login',
        ),
      );
}

final class LoginScreen extends StatelessWidget {
  final ApiInfo apiInfo;

  const LoginScreen({
    super.key,
    required this.apiInfo,
  }) : super();

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Container(
          margin: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.25),
          child: FormProvider<LoginControllers, LoginParams, LoginResponse>(
            createControllers: (_) => LoginControllers(),
            createLoader: (_) => LoaderBloc(
              load: (params) => login(
                params: params,
                apiInfo: apiInfo,
              ),
            ),
            listener: (context, controllers, loginState, _) {
              switch (loginState) {
                case LoaderLoadedState(data: final response):
                  switch (response) {
                    case LoginSuccess(session: final session):
                      context.sessionLoader
                          .add(LoaderSetEvent(RefreshSessionSuccess(session)));
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute<void>(
                          builder: (context) => HomeScreen(
                            initialSession: session,
                          ),
                        ),
                        (_) => false,
                      );
                    case LoginChangePasswordRequired(user: final user):
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (context) => ChangePasswordScreen(
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
            },
            builder: (context, controllers, loginState, submit) {
              void submitForm() => submit(
                    LoginParams(
                      email: controllers.emailController.text,
                      password: controllers.passwordController.text,
                    ),
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
                  switch (loginState) {
                    LoaderLoadingState() => const CircularProgressIndicator(),
                    _ => LoginButton(onSubmit: submitForm),
                  },
                ],
              );
            },
          ),
        ),
      );
}
