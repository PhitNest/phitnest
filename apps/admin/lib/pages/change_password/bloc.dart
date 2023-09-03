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
