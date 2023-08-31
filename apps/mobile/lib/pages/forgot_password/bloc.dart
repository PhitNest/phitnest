part of 'forgot_password.dart';

final class ForgotPasswordControllers extends FormControllers {
  final emailController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final pageController = PageController();

  @override
  void dispose() {
    emailController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    pageController.dispose();
  }
}

typedef ForgotPasswordProvider = FormProvider<ForgotPasswordControllers, String,
    SendForgotPasswordResponse>;

ForgotPasswordProvider forgotPasswordForm(
        ApiInfo apiInfo,
        CreateFormConsumer<ForgotPasswordControllers, String,
                SendForgotPasswordResponse>
            createConsumer) =>
    ForgotPasswordProvider(
      createControllers: (_) => ForgotPasswordControllers(),
      createLoader: (_) => LoaderBloc(
        load: (email) => sendForgotPasswordRequest(
          email: email,
          apiInfo: apiInfo,
        ),
      ),
      createConsumer: createConsumer,
    );
