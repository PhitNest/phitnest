part of 'invite_form.dart';

final class InviteFormControllers extends FormControllers {
  final emailController = TextEditingController();
  final gymIdController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    gymIdController.dispose();
  }
}

typedef InviteFormProvider
    = AuthFormProvider<InviteFormControllers, InviteParams, HttpResponse<void>>;

InviteFormProvider _inviteForm(
  CreateAuthFormConsumer<InviteFormControllers, InviteParams,
          HttpResponse<void>>
      createConsumer,
) =>
    InviteFormProvider(
      createControllers: (_) => InviteFormControllers(),
      createLoader: (_) => AuthLoaderBloc(load: createInvite),
      createConsumer: createConsumer,
    );
