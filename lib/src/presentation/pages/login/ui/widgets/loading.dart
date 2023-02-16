part of login_page;

class _LoadingPage extends _ILoginPage {
  const _LoadingPage({
    required super.autovalidateMode,
    required super.invalidCredentials,
    required super.emailController,
    required super.passwordController,
    required super.formKey,
    required super.keyboardHeight,
    required super.onPressedForgotPassword,
    required super.onPressedRegister,
  }) : super(
          child: const CircularProgressIndicator(),
        );
}
