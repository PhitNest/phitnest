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
            createConsumer: (context, controllers, submit) => LoaderConsumer(
              listener: (context, loaderState) {
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
