import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phitnest_core/core.dart';

import '../confirm_email/confirm_email.dart';
import '../forgot_password/forgot_password.dart';
import '../home/home.dart';
import '../register/register.dart';

part 'bloc.dart';
part 'ui.dart';

final class LoginScreen extends StatelessWidget {
  final ApiInfo apiInfo;

  const LoginScreen({
    super.key,
    required this.apiInfo,
  }) : super();

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 40.w),
          child: FormProvider<LoginControllers, LoginParams, LoginResponse>(
            load: (params) => login(
              params: params,
              apiInfo: apiInfo,
            ),
            createControllers: (_) => LoginControllers(),
            formBuilder: (
              context,
              controllers,
              consumer,
            ) {
              params() => LoginParams(
                    email: controllers.emailController.text,
                    password: controllers.passwordController.text,
                  );
              return consumer(
                listener: (context, loginState, _) {
                  switch (loginState) {
                    case LoaderLoadedState(data: final response):
                      switch (response) {
                        case LoginSuccess():
                          Navigator.pushAndRemoveUntil(
                            context,
                            CupertinoPageRoute<void>(
                              builder: (context) => HomeScreen(
                                apiInfo: apiInfo,
                              ),
                            ),
                            (_) => false,
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
                                loginParams: params(),
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
                      onFieldSubmitted: (_) => submit(params()),
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
                    switch (loginState) {
                      LoaderLoadingState() => const CircularProgressIndicator(),
                      LoaderInitialState() ||
                      LoaderLoadedState() =>
                        ElevatedButton(
                          onPressed: () => submit(params()),
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
                                context.loginBloc
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
              );
            },
          ),
        ),
      );
}
