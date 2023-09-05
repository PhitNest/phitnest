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
  CreateFormConsumer<LoginControllers, LoginParams, LoginResponse>
      createConsumer,
) =>
    LoginProvider(
      createControllers: (_) => LoginControllers(),
      createLoader: (_) => LoaderBloc(load: login),
      createConsumer: createConsumer,
    );

void _handleStateChanged(
  BuildContext context,
  LoaderState<LoginResponse> loaderState,
) {
  switch (loaderState) {
    case LoaderLoadedState(data: final response):
      switch (response) {
        case LoginSuccess(session: final session):
          context.sessionLoader
              .add(LoaderSetEvent(RefreshSessionSuccess(session)));
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute<void>(
              builder: (_) => const HomePage(),
            ),
            (_) => false,
          );
        case LoginChangePasswordRequired(user: final user):
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (context) => ChangePasswordPage(
                unauthenticatedSession: UnauthenticatedSession(
                  user: user,
                ),
              ),
            ),
          );
        case LoginFailureResponse(message: final message):
          StyledBanner.show(
            message: message,
            error: true,
          );
      }
    default:
  }
}
