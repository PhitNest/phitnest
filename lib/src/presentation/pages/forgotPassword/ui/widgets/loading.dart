part of forgot_password_page;

class _LoadingPage extends _IBasePage {
  const _LoadingPage({
    required super.emailController,
    required super.passwordController,
    required super.confirmPassController,
    required super.autovalidateMode,
    required super.formKey,
  }) : super(child: const CircularProgressIndicator());
}
