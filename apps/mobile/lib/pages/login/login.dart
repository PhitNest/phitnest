import 'package:core/core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ui/ui.dart';

import '../pages.dart';

part 'bloc.dart';

LoginParams _params(LoginControllers controllers) => LoginParams(
      email: controllers.emailController.text,
      password: controllers.passwordController.text,
    );

void _handleStateChanged(BuildContext context, LoginControllers controllers,
    LoaderState<LoginResponse> loaderState) {
  switch (loaderState) {
    case LoaderLoadedState(data: final response):
      switch (response) {
        case LoginSuccess():
          Navigator.pushAndRemoveUntil(
            context,
            CupertinoPageRoute<void>(
              builder: (_) => const HomePage(),
            ),
            (_) => false,
          );
        case LoginConfirmationRequired(user: final user):
          Navigator.pushReplacement(
            context,
            CupertinoPageRoute<void>(
              builder: (context) => VerificationPage(
                unauthenticatedSession: UnauthenticatedSession(user: user),
                resend: (session) => resendConfirmationEmail(
                  user: session.user,
                ),
                confirm: (session, code) => confirmEmail(
                  user: session.user,
                  code: code,
                ),
                loginParams: _params(controllers),
              ),
            ),
          );
        case LoginFailureResponse(message: final message) ||
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

final class LoginPage extends StatelessWidget {
  const LoginPage({super.key}) : super();

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 40.w),
          child: _loginForm(
            (context, controllers, submit) => LoaderConsumer(
              listener: (context, loaderState) =>
                  _handleStateChanged(context, controllers, loaderState),
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
                              builder: (context) =>
                                  const ForgotPasswordScreen(),
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
                                  builder: (context) => const RegisterPage(),
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
