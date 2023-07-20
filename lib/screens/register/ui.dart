import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phitnest_core/core.dart';

import '../confirm_email.dart';

part 'pages/account_info.dart';
part 'pages/inviter_email.dart';
part 'pages/loading.dart';
part 'pages/name.dart';

final class RegisterControllers extends FormControllers {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final inviterEmailController = TextEditingController();
  final pageController = PageController();

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    inviterEmailController.dispose();
    pageController.dispose();
  }
}

final class RegisterScreen extends StatelessWidget {
  final ApiInfo apiInfo;

  const RegisterScreen({
    super.key,
    required this.apiInfo,
  }) : super();

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 40.w),
          child: FormProvider<RegisterControllers, RegisterParams,
              RegisterResponse>(
            createControllers: (_) => RegisterControllers(),
            load: (params) => register(
              params: params,
              pool: apiInfo.pool,
            ),
            formBuilder: (context, controllers, consumer) => consumer(
              listener: (context, loaderState, _) {
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
                            builder: (context) => ConfirmEmailScreen(
                              loginParams: loginParams,
                              resendConfirmationEmail: (session) =>
                                  resendConfirmationEmail(
                                user: session.user,
                              ),
                              confirmEmail: (session, code) => confirmEmail(
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
              },
              builder: (context, loaderState, submit) {
                nextPage() => controllers.pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                return switch (loaderState) {
                  LoaderLoadingState() => const RegisterLoadingPage(),
                  _ => PageView(
                      controller: controllers.pageController,
                      children: [
                        RegisterNamePage(
                          controllers: controllers,
                          onSubmit: nextPage,
                        ),
                        RegisterAccountInfoPage(
                          controllers: controllers,
                          onSubmit: nextPage,
                        ),
                        RegisterInviterEmailPage(
                          controllers: controllers,
                          onSubmit: () => submit(
                            RegisterParams(
                              email: controllers.emailController.text,
                              password: controllers.passwordController.text,
                              firstName: controllers.firstNameController.text,
                              lastName: controllers.lastNameController.text,
                              inviterEmail:
                                  controllers.inviterEmailController.text,
                            ),
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
