part of forgot_password_page;

class _InitialPage extends _BasePage {
  _InitialPage({
    required VoidCallback onSubmit,
    required super.emailController,
    required super.passwordController,
    required super.confirmPassController,
    required super.autovalidateMode,
    required super.formKey,
  }) : super(
          onSubmit: onSubmit,
          child: StyledButton(
            text: 'SUBMIT',
            onPressed: onSubmit,
          ),
        );
}
