part of 'verification.dart';

class VerificationControllers extends FormControllers {
  final focusNode = FocusNode();
  final codeController = TextEditingController();

  @override
  void dispose() {
    codeController.dispose();
    focusNode.dispose();
  }
}

typedef ResendLoaderBloc = LoaderBloc<UnauthenticatedSession, String?>;
typedef ResendLoaderConsumer = LoaderConsumer<UnauthenticatedSession, String?>;

extension on BuildContext {
  ResendLoaderBloc get resendEmailLoaderBloc => loader();
}

typedef VerificationProvider
    = FormProvider<VerificationControllers, String, LoginResponse?>;

VerificationProvider verificationForm(
  Future<LoginResponse?> Function(String code) confirm,
  CreateFormConsumer<VerificationControllers, String, LoginResponse?>
      createConsumer,
) =>
    FormProvider(
      createLoader: (_) => LoaderBloc(load: confirm),
      createControllers: (_) => VerificationControllers(),
      createConsumer: createConsumer,
    );
