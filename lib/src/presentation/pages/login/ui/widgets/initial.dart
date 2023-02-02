part of login_page;

class _InitialPage extends _LoginPageBase {
  _InitialPage({
    required VoidCallback onSubmit,
    required super.autovalidateMode,
    required super.invalidCredentials,
    required super.emailController,
    required super.passwordController,
    required super.formKey,
    required super.keyboardHeight,
    required super.onPressedForgotPassword,
    required super.onPressedRegister,
  }) : super(
          onSubmit: onSubmit,
          child: StyledButton(
            text: 'SIGN IN',
            onPressed: onSubmit,
          ),
        );
}
