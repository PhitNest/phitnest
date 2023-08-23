part of 'confirm_email.dart';

class ConfirmEmailControllers extends FormControllers {
  final focusNode = FocusNode();
  final codeController = TextEditingController();

  @override
  void dispose() {
    codeController.dispose();
    focusNode.dispose();
  }
}

typedef ResendEmailLoaderBloc = LoaderBloc<void, bool>;
typedef ResendEmailLoaderConsumer = LoaderConsumer<void, bool>;

typedef ConfirmEmailBloc = LoaderBloc<String, LoginResponse?>;

extension on BuildContext {
  ResendEmailLoaderBloc get resendEmailLoaderBloc => loader();
}
