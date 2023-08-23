part of 'register.dart';

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
            createLoader: (_) => LoaderBloc(
              load: (params) => register(
                params: params,
                pool: apiInfo.pool,
              ),
            ),
            listener: (context, controllers, loaderState, _) {
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
                            apiInfo: apiInfo,
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
            builder: (context, controllers, loaderState, submit) {
              void finishPage() {
                if ((context.registerFormBloc.formKey.currentState
                        ?.validate()) ??
                    false) {
                  controllers.pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                }
              }

              return switch (loaderState) {
                LoaderLoadingState() =>
                  const Center(child: CircularProgressIndicator()),
                _ => PageView(
                    controller: controllers.pageController,
                    children: [
                      RegisterNamePage(
                        controllers: controllers,
                        onSubmit: finishPage,
                      ),
                      RegisterAccountInfoPage(
                        controllers: controllers,
                        onSubmit: finishPage,
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
      );
}
