part of 'gym_entry_form.dart';

final class GymEntryFormControllers extends FormControllers {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final nameController = TextEditingController();
  final streetController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final zipCodeController = TextEditingController();

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    nameController.dispose();
    streetController.dispose();
    cityController.dispose();
    stateController.dispose();
    zipCodeController.dispose();
  }
}

typedef GymEntryFormProvider = AuthFormProvider<GymEntryFormControllers,
    CreateGymParams, HttpResponse<void>>;

GymEntryFormProvider _gymEntryForm(
  CreateAuthFormConsumer<GymEntryFormControllers, CreateGymParams,
          HttpResponse<void>>
      createConsumer,
) =>
    GymEntryFormProvider(
      createControllers: (_) => GymEntryFormControllers(),
      createLoader: (_) => AuthLoaderBloc(load: createGym),
      createConsumer: createConsumer,
    );
