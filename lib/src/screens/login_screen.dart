import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phitnest_core/core.dart';

import 'forgot_password/ui.dart';

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
            screenState,
            formKey,
            emailController,
            passwordController,
            consumer,
            submit,
          ) =>
              Padding(
            padding: EdgeInsets.symmetric(horizontal: 40.w),
            child: Form(
              key: formKey,
              autovalidateMode: screenState.autovalidateMode,
              child: Column(
                children: [
                  120.verticalSpace,
                  Text(
                    'Login',
                    style: AppTheme.instance.theme.textTheme.bodyLarge,
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
                    onFieldSubmitted: (_) => submit(),
                  ),
                  Row(
                    children: [
                      TextButton(
                        onPressed: () => Navigator.push(
                          context,
                          CupertinoPageRoute<void>(
                            builder: (context) => const ForgotPasswordScreen(),
                          ),
                        ),
                        child: Text(
                          'Forgot Password?',
                          style: AppTheme.instance.theme.textTheme.bodySmall!
                              .copyWith(fontStyle: FontStyle.normal),
                        ),
                      ),
                    ],
                  ),
                  8.verticalSpace,
                  consumer(
                    listener: (context, loginState) {
                      switch (loginState) {
                        case LoaderLoadedState(data: final response):
                          switch (response) {
                            case LoginSuccess():
                              Navigator.pushReplacement(
                                context,
                                CupertinoPageRoute<void>(
                                  builder: (context) => const Scaffold(),
                                ),
                              );
                            case LoginConfirmationRequired():
                              Navigator.pushReplacement(
                                context,
                                CupertinoPageRoute<void>(
                                  builder: (context) => const Scaffold(),
                                ),
                              );
                            case LoginFailure(message: final message) ||
                                  LoginUnknownResponse(
                                    message: final message
                                  ) ||
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
                    builder: (context, loginState) => switch (loginState) {
                      LoaderLoadingState() => const CircularProgressIndicator(),
                      LoaderInitialState() ||
                      LoaderLoadedState() =>
                        ElevatedButton(
                          onPressed: submit,
                          child: Text(
                            'LOGIN',
                            style: AppTheme.instance.theme.textTheme.bodySmall,
                          ),
                        ),
                    },
                  ),
                  32.verticalSpace,
                  RichText(
                    text: TextSpan(
                      text: "Don't have an account?",
                      style: AppTheme.instance.theme.textTheme.bodySmall,
                      children: [
                        TextSpan(
                          text: 'Register',
                          style: AppTheme.instance.theme.textTheme.bodySmall!
                              .copyWith(
                            color: AppTheme.instance.theme.colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => Navigator.of(context).push(
                                  CupertinoPageRoute<void>(
                                    builder: (context) =>
                                        // const RegisterScreen(),
                                        const Scaffold(),
                                  ),
                                ),
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
