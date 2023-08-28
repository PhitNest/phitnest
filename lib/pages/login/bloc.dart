part of 'login.dart';

final class LoginControllers extends FormControllers {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
  }
}

typedef LoginProvider
    = FormProvider<LoginControllers, LoginParams, LoginResponse>;

LoginProvider loginForm(
  ApiInfo apiInfo,
  CreateFormConsumer<LoginControllers, LoginParams, LoginResponse>
      createConsumer,
) =>
    LoginProvider(
      createControllers: (_) => LoginControllers(),
      createLoader: (_) => LoaderBloc(
        load: (params) => login(params: params, apiInfo: apiInfo),
      ),
      createConsumer: createConsumer,
    );
