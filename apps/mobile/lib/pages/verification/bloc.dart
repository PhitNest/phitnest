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

void _handleResendStateChanged(
    BuildContext context, LoaderState<String?> loaderState) {
  switch (loaderState) {
    case LoaderLoadedState(data: final error):
      if (error == null) {
        StyledBanner.show(
          message: 'Email resent',
          error: false,
        );
      } else {
        StyledBanner.show(
          message: error,
          error: true,
        );
      }
    default:
  }
}

void _handleConfirmStateChanged(
  BuildContext context,
  VerificationControllers controllers,
  LoaderState<LoginResponse?> loaderState,
) {
  switch (loaderState) {
    case LoaderLoadedState(data: final response):
      if (response != null) {
        switch (response) {
          case LoginSuccess():
            Navigator.pushAndRemoveUntil(
              context,
              CupertinoPageRoute<void>(
                builder: (_) => const HomePage(),
              ),
              (_) => false,
            );
          case LoginFailureResponse(message: final message):
            StyledBanner.show(message: message, error: true);
            controllers.codeController.clear();
        }
      } else {
        StyledBanner.show(message: 'Invalid code', error: true);
        controllers.codeController.clear();
      }
    default:
  }
}
