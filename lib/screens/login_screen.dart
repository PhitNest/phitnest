import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phitnest_core/core.dart';

import 'confirm_email.dart';
import 'forgot_password.dart';
import 'home/ui.dart';
import 'register/ui.dart';

extension on BuildContext {
  LoginLoaderBloc get loginLoaderBloc => loader();
}

class LoginScreen extends StatelessWidget {
  final ApiInfo apiInfo;

  const LoginScreen({
    super.key,
    required this.apiInfo,
  }) : super();

  @override
  Widget build(BuildContext context) => Scaffold(
        body: LoginProvider(
          apiInfo: apiInfo,
          formBuilder: (
            context,
            autovalidateMode,
            formKey,
            emailController,
            passwordController,
            consumer,
          ) =>
              Padding(
            padding: EdgeInsets.symmetric(horizontal: 40.w),
            child: Form(
              key: formKey,
              autovalidateMode: autovalidateMode,
              child: consumer(
                listener: (context, loginState, _) {
                  switch (loginState) {
                    case LoaderLoadedState(data: final response):
                      switch (response) {
                        case LoginSuccess():
                          Navigator.pushReplacement(
                            context,
                            CupertinoPageRoute<void>(
                              builder: (context) => HomeScreen(
                                apiInfo: apiInfo,
                              ),
                            ),
                          );
                        case LoginConfirmationRequired(user: final user):
                          Navigator.pushReplacement(
                            context,
                            CupertinoPageRoute<void>(
                              builder: (context) => ConfirmEmailScreen(
                                unauthenticatedSession: UnauthenticatedSession(
                                  apiInfo: apiInfo,
                                  user: user,
                                ),
                                resendConfirmationEmail: (session) =>
                                    resendConfirmationEmail(
                                  user: session.user,
                                ),
                                confirmEmail: (session, code) => confirmEmail(
                                  user: session.user,
                                  code: code,
                                ),
                                loginParams: LoginParams(
                                  email: emailController.text,
                                  password: passwordController.text,
                                ),
                              ),
                            ),
                          );
                        case LoginFailure(message: final message) ||
                              LoginUnknownResponse(message: final message) ||
                              LoginChangePasswordRequired(
                                message: final message
                              ):
                          StyledBanner.show(
                            message: message,
                            error: true,
                          );
                      }
                    default:
                  }
                },
                builder: (context, loginState, submit) => Column(
                  children: [
                    120.verticalSpace,
                    Text(
                      'Login',
                      style: theme.textTheme.bodyLarge,
                    ),
                    70.verticalSpace,
                    StyledUnderlinedTextField(
                      hint: 'Email',
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      validator: EmailValidator.validateEmail,
                    ),
                    24.verticalSpace,
                    StyledPasswordField(
                      hint: 'Password',
                      controller: passwordController,
                      textInputAction: TextInputAction.done,
                      validator: validatePassword,
                      onFieldSubmitted: (_) => switch (loginState) {
                        LoaderLoadingState() => {},
                        _ => submit(),
                      },
                    ),
                    Row(
                      children: [
                        TextButton(
                          onPressed: () {
                            context.loginLoaderBloc
                                .add(const LoaderCancelEvent());
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
                    switch (loginState) {
                      LoaderLoadingState() => const CircularProgressIndicator(),
                      LoaderInitialState() ||
                      LoaderLoadedState() =>
                        ElevatedButton(
                          onPressed: submit,
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
                                context.loginLoaderBloc
                                    .add(const LoaderCancelEvent());
                                Navigator.of(context).push(
                                  CupertinoPageRoute<void>(
                                    builder: (context) => RegisterScreen(
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
        ),
      );
}
