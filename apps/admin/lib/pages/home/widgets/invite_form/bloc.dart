part of 'invite_form.dart';

final class InviteFormControllers extends FormControllers {
  final emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
  }
}

typedef InviteFormProvider
    = AuthFormProvider<InviteFormControllers, String, HttpResponse<void>>;

InviteFormProvider _inviteForm(
  CreateAuthFormConsumer<InviteFormControllers, String, HttpResponse<void>>
      createConsumer,
) =>
    InviteFormProvider(
      createControllers: (_) => InviteFormControllers(),
      createLoader: (_) => AuthLoaderBloc(load: createInvite),
      createConsumer: createConsumer,
    );
