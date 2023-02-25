part of registration_page;

class _PageTwo extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final GlobalKey<FormState> formKey;
  final FocusNode emailFocusNode;
  final FocusNode passwordFocusNode;
  final FocusNode confirmPasswordFocusNode;
  final AutovalidateMode autovalidateMode;
  final String firstName;
  final VoidCallback onSubmit;
  final Set<String> takenEmails;

  const _PageTwo({
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.formKey,
    required this.emailFocusNode,
    required this.passwordFocusNode,
    required this.confirmPasswordFocusNode,
    required this.autovalidateMode,
    required this.firstName,
    required this.onSubmit,
    required this.takenEmails,
  }) : super();

  @override
  Widget build(BuildContext context) => Column(
        children: [
          80.verticalSpace,
          Text(
            "Hi, $firstName.\nLet's make an account.",
            style: theme.textTheme.headlineLarge,
            textAlign: TextAlign.center,
          ),
          32.verticalSpace,
          SizedBox(
            width: 291.w,
            child: Form(
              key: formKey,
              autovalidateMode: autovalidateMode,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  StyledUnderlinedTextField(
                    errorMaxLines: 1,
                    hint: 'Email',
                    controller: emailController,
                    validator: (value) =>
                        validateEmail(value) ??
                        (takenEmails.contains(emailController.text)
                            ? 'Email already in use.'
                            : null),
                    textInputAction: TextInputAction.next,
                    focusNode: emailFocusNode,
                  ),
                  StyledPasswordField(
                    hint: 'Password',
                    controller: passwordController,
                    validator: (value) => validatePassword(value),
                    textInputAction: TextInputAction.next,
                    focusNode: passwordFocusNode,
                  ),
                  StyledPasswordField(
                    hint: 'Confirm password',
                    controller: confirmPasswordController,
                    onFieldSubmitted: (val) => onSubmit(),
                    focusNode: confirmPasswordFocusNode,
                    validator: (value) => passwordController.text ==
                            confirmPasswordController.text
                        ? null
                        : "Passwords don't match",
                  ),
                ],
              ),
            ),
          ),
          40.verticalSpace,
          StyledButton(
            onPressed: onSubmit,
            text: "NEXT",
          ),
        ],
      );
}
