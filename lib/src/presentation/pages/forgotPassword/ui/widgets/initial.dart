part of forgot_password_page;

class _InitialPage extends _BasePage {
  final VoidCallback onSubmit;

  _InitialPage({
    required super.emailController,
    required super.passwordController,
    required super.confirmPassController,
    required super.autovalidateMode,
    required super.formKey,
    required this.onSubmit,
  }) : super(
          onSubmit: onSubmit,
          child: StyledButton(
            text: 'SUBMIT',
            onPressed: onSubmit,
          ),
        );
}
