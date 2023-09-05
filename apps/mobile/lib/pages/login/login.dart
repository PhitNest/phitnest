import 'package:core/core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ui/ui.dart';

import '../pages.dart';

part 'bloc.dart';

final class LoginPage extends StatelessWidget {
  const LoginPage({super.key}) : super();

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Padding(
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
                            text: ' Register',
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
        ),
      );
}
