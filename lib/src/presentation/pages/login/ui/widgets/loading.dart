part of login_page;

class LoginLoading extends LoginPageBase {
  const LoginLoading({
    required super.emailController,
    required super.passwordController,
    required super.emailFocusNode,
    required super.passwordFocusNode,
    required super.formKey,
    required super.keyboardHeight,
    required super.autovalidateMode,
    required super.onSubmit,
    required super.onPressedForgotPassword,
    required super.onPressedRegister,
    required super.invalidCredentials,
  }) : super(child: const CircularProgressIndicator());
}
