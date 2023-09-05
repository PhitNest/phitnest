part of 'register.dart';

final class RegisterControllers extends FormControllers {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final pageController = PageController();

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    pageController.dispose();
  }
}

extension on BuildContext {
  FormBloc<RegisterControllers> get registerFormBloc => BlocProvider.of(this);
}

typedef RegisterProvider
    = FormProvider<RegisterControllers, RegisterParams, RegisterResponse>;

RegisterProvider registerForm(
  CreateFormConsumer<RegisterControllers, RegisterParams, RegisterResponse>
      createConsumer,
) =>
    RegisterProvider(
      createControllers: (_) => RegisterControllers(),
      createLoader: (_) => LoaderBloc(load: register),
      createConsumer: createConsumer,
    );

void _handleStateChanged(
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
                resend: (session) => resendConfirmationEmail(
                  user: session.user,
                ),
                confirm: (session, code) => confirmEmail(
                  user: session.user,
                  code: code,
                ),
                unauthenticatedSession: UnauthenticatedSession(user: user),
              ),
            ),
          );
        case RegisterFailureResponse(message: final message):
          StyledBanner.show(message: message, error: true);
      }
    default:
  }
}
