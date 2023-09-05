part of 'change_password.dart';

final class ChangePasswordControllers extends FormControllers {
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
  }
}

typedef ChangePasswordProvider
    = FormProvider<ChangePasswordControllers, String, ChangePasswordResponse>;

ChangePasswordProvider _changePasswordForm(
        UnauthenticatedSession unauthenticatedSession,
        CreateFormConsumer<ChangePasswordControllers, String,
                ChangePasswordResponse>
            createConsumer) =>
    ChangePasswordProvider(
      createControllers: (_) => ChangePasswordControllers(),
      createLoader: (_) => LoaderBloc(
        load: (newPassword) => changePassword(
          unauthenticatedSession: unauthenticatedSession,
          newPassword: newPassword,
        ),
      ),
      createConsumer: createConsumer,
    );

void _handleStateChanged(
  BuildContext context,
  LoaderState<ChangePasswordResponse> loaderState,
) {
  switch (loaderState) {
    case LoaderLoadedState(data: final response):
      switch (response) {
        case ChangePasswordSuccess(session: final session):
          context.sessionLoader
              .add(LoaderSetEvent(RefreshSessionSuccess(session)));
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute<void>(
              builder: (_) => const HomePage(),
            ),
            (_) => false,
          );
        case ChangePasswordFailureResponse(message: final message):
          StyledBanner.show(
            message: message,
            error: true,
          );
      }
    default:
  }
}
