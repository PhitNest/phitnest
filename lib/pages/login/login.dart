import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phitnest_core/core.dart';

import '../pages.dart';

part 'bloc.dart';

LoginParams _params(LoginControllers controllers) => LoginParams(
      email: controllers.emailController.text,
      password: controllers.passwordController.text,
    );

final class LoginPage extends StatelessWidget {
  final ApiInfo apiInfo;

  void handleStateChanged(BuildContext context, LoginControllers controllers,
      LoaderState<LoginResponse> loaderState) {
    switch (loaderState) {
      case LoaderLoadedState(data: final response):
        switch (response) {
          case LoginSuccess():
            Navigator.pushAndRemoveUntil(
              context,
              CupertinoPageRoute<void>(
                builder: (context) => HomePage(apiInfo: apiInfo),
              ),
              (_) => false,
            );
          case LoginConfirmationRequired(user: final user):
            Navigator.pushReplacement(
              context,
              CupertinoPageRoute<void>(
                builder: (context) => VerificationPage(
                  unauthenticatedSession: UnauthenticatedSession(
                    apiInfo: apiInfo,
                    user: user,
                  ),
                  resend: (session) => resendConfirmationEmail(
                    user: session.user,
                  ),
                  confirm: (session, code) => confirmEmail(
                    user: session.user,
                    code: code,
                  ),
                  apiInfo: apiInfo,
                  loginParams: _params(controllers),
                ),
              ),
            );
          case LoginFailure(message: final message) ||
                LoginUnknownResponse(message: final message) ||
                LoginChangePasswordRequired(message: final message):
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
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 40.w),
          child: loginForm(
            apiInfo,
            (context, controllers, submit) => LoaderConsumer(
              listener: (context, loaderState) =>
                  handleStateChanged(context, controllers, loaderState),
              builder: (context, loaderState) => Column(
                children: [
                  120.verticalSpace,
                  Text(
                    'Login',
                    style: theme.textTheme.bodyLarge,
                  ),
                  70.verticalSpace,
                  StyledUnderlinedTextField(
                    hint: 'Email',
                    controller: controllers.emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    validator: EmailValidator.validateEmail,
                  ),
                  24.verticalSpace,
                  StyledPasswordField(
                    hint: 'Password',
                    controller: controllers.passwordController,
                    textInputAction: TextInputAction.done,
                    validator: validatePassword,
                    onFieldSubmitted: (_) =>
                        submit(_params(controllers), loaderState),
                  ),
                  Row(
                    children: [
                      TextButton(
                        onPressed: () {
                          context.loginBloc.add(const LoaderCancelEvent());
                          Navigator.push(
                            context,
                            CupertinoPageRoute<void>(
                              builder: (context) => ForgotPasswordScreen(
                                apiInfo: apiInfo,
                              ),
                            ),
                          );
                        },
                        child: Text(
                          'Forgot Password?',
                          style: theme.textTheme.bodySmall!
                              .copyWith(fontStyle: FontStyle.normal),
                        ),
                      ),
                    ],
                  ),
                  8.verticalSpace,
                  switch (loaderState) {
                    LoaderLoadingState() => const CircularProgressIndicator(),
                    LoaderInitialState() ||
                    LoaderLoadedState() =>
                      ElevatedButton(
                        onPressed: () =>
                            submit(_params(controllers), loaderState),
                        child: Text(
                          'LOGIN',
                          style: theme.textTheme.bodySmall,
                        ),
                      ),
                  },
                  32.verticalSpace,
                  RichText(
                    text: TextSpan(
                      text: "Don't have an account?",
                      style: theme.textTheme.bodySmall,
                      children: [
                        TextSpan(
                          text: 'Register',
                          style: theme.textTheme.bodySmall!.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              context.loginBloc.add(const LoaderCancelEvent());
                              Navigator.of(context).push(
                                CupertinoPageRoute<void>(
                                  builder: (context) => RegisterPage(
                                    apiInfo: apiInfo,
                                  ),
                                ),
                              );
                            },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
