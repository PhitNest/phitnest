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

InviteFormProvider inviteForm(
  ApiInfo apiInfo,
  CreateAuthFormConsumer<InviteFormControllers, InviteParams,
          HttpResponse<void>>
      createConsumer,
) =>
    InviteFormProvider(
      createControllers: (_) => InviteFormControllers(),
      createLoader: (_) => AuthLoaderBloc(
        apiInfo: apiInfo,
        load: createInvite,
      ),
      createConsumer: createConsumer,
    );
