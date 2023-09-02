part of 'gym_entry_form.dart';

final class GymEntryFormControllers extends FormControllers {
  final nameController = TextEditingController();
  final streetController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final zipCodeController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    streetController.dispose();

    cityController.dispose();
    stateController.dispose();
    zipCodeController.dispose();
  }
}

typedef GymEntryFormProvider = AuthFormProvider<GymEntryFormControllers,
    CreateGymParams, HttpResponse<CreateGymSuccess>>;

GymEntryFormProvider gymEntryForm(
  CreateAuthFormConsumer<GymEntryFormControllers, CreateGymParams,
          HttpResponse<CreateGymSuccess>>
      createConsumer,
) =>
    GymEntryFormProvider(
      createControllers: (_) => GymEntryFormControllers(),
      createLoader: (_) => AuthLoaderBloc(load: createGym),
      createConsumer: createConsumer,
    );
