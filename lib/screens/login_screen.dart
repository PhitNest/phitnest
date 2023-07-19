import 'package:flutter/material.dart';
import 'package:phitnest_core/core.dart';

import 'change_password.dart';
import 'home_screen.dart';

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
          child: LoginProvider(
            apiInfo: apiInfo,
            formBuilder: (
              context,
              autovalidateMode,
              formKey,
              emailController,
              passwordController,
              consumer,
              submit,
            ) =>
                Form(
              key: formKey,
              autovalidateMode: autovalidateMode,
              child: Column(
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
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    validator: EmailValidator.validateEmail,
                  ),
                  StyledPasswordField(
                    hint: 'Password',
                    controller: passwordController,
                    textInputAction: TextInputAction.done,
                    validator: validatePassword,
                    onFieldSubmitted: (_) => submit(),
                  ),
                  consumer(
                    listener: (context, loginState) {
                      switch (loginState) {
                        case LoaderLoadedState(data: final response):
                          switch (response) {
                            case LoginSuccess(session: final session):
                              context.sessionLoader.add(LoaderSetEvent(
                                  RefreshSessionSuccess(session)));
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute<void>(
                                  builder: (context) => HomeScreen(
                                    apiInfo: apiInfo,
                                  ),
                                ),
                              );
                            case LoginChangePasswordRequired(user: final user):
                              Navigator.of(context).push(
                                MaterialPageRoute<void>(
                                  builder: (context) => ChangePasswordScreen(
                                    apiInfo: apiInfo,
                                    user: ChangePasswordUser(
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
                    builder: (context, loginState) => switch (loginState) {
                      LoaderLoadingState() => const CircularProgressIndicator(),
                      _ => LoginButton(
                          onSubmit: submit,
                        ),
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
