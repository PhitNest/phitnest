import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phitnest_core/core.dart';

import '../verification/verification.dart';
import 'widgets/widgets.dart';

part 'bloc.dart';

final class RegisterPage extends StatelessWidget {
  final ApiInfo apiInfo;

  const RegisterPage({
    super.key,
    required this.apiInfo,
  }) : super();

  void handleStateChanged(
    BuildContext context,
    RegisterControllers controllers,
    LoaderState<RegisterResponse> loaderState,
  ) {
    switch (loaderState) {
      case LoaderLoadedState(data: final response):
        switch (response) {
          case RegisterSuccess(user: final user):
            final LoginParams loginParams = LoginParams(
              email: controllers.emailController.text,
              password: controllers.passwordController.text,
            );
            Navigator.pushReplacement(
              context,
              CupertinoPageRoute<void>(
                builder: (context) => VerificationPage(
                  loginParams: loginParams,
                  apiInfo: apiInfo,
                  resend: (session) => resendConfirmationEmail(
                    user: session.user,
                  ),
                  confirm: (session, code) => confirmEmail(
                    user: session.user,
                    code: code,
                  ),
                  unauthenticatedSession: UnauthenticatedSession(
                    user: user,
                    apiInfo: apiInfo,
                  ),
                ),
              ),
            );
          case RegisterFailureResponse(message: final message):
            StyledBanner.show(message: message, error: true);
        }
      default:
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 40.w),
          child: registerForm(
            apiInfo,
            (context, controllers, submit) => LoaderConsumer(
              listener: (context, loaderState) =>
                  handleStateChanged(context, controllers, loaderState),
              builder: (context, loaderState) {
                return switch (loaderState) {
                  LoaderLoadingState() =>
                    const Center(child: CircularProgressIndicator()),
                  _ => PageView(
                      controller: controllers.pageController,
                      children: [
                        RegisterNamePage(
                          controllers: controllers,
                          onSubmit: () {
                            if ((context.registerFormBloc.formKey.currentState
                                    ?.validate()) ??
                                false) {
                              controllers.pageController.nextPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            }
                          },
                        ),
                        RegisterAccountInfoPage(
                          controllers: controllers,
                          onSubmit: () => submit(
                            RegisterParams(
                              email: controllers.emailController.text,
                              password: controllers.passwordController.text,
                              firstName: controllers.firstNameController.text,
                              lastName: controllers.lastNameController.text,
                            ),
                            loaderState,
                          ),
                        ),
                      ],
                    ),
                };
              },
            ),
          ),
        ),
      );
}
