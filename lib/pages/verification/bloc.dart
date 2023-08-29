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

typedef ResendLoaderBloc = LoaderBloc<UnauthenticatedSession, bool>;
typedef ResendLoaderConsumer = LoaderConsumer<UnauthenticatedSession, bool>;

extension on BuildContext {
  ResendLoaderBloc get resendEmailLoaderBloc => loader();
}

typedef VerificationProvider
    = FormProvider<VerificationControllers, String, LoginResponse?>;

VerificationProvider verificationForm(
  ApiInfo apiInfo,
  Future<LoginResponse?> Function(String code) confirm,
  CreateFormConsumer<VerificationControllers, String, LoginResponse?>
      createConsumer,
) =>
    FormProvider(
      createLoader: (_) => LoaderBloc(load: confirm),
      createControllers: (_) => VerificationControllers(),
      createConsumer: createConsumer,
    );
