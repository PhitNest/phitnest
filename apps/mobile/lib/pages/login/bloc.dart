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

extension on BuildContext {
  LoaderBloc<LoginParams, LoginResponse> get loginBloc => loader();
}

typedef LoginProvider
    = FormProvider<LoginControllers, LoginParams, LoginResponse>;

LoginProvider loginForm(
  CreateFormConsumer<LoginControllers, LoginParams, LoginResponse>
      createConsumer,
) =>
    LoginProvider(
      createControllers: (_) => LoginControllers(),
      createLoader: (_) => LoaderBloc(load: login),
      createConsumer: createConsumer,
    );
