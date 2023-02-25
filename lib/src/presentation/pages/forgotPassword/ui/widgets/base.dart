part of forgot_password_page;

abstract class _IBasePage extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPassController;
  final AutovalidateMode autovalidateMode;
  final GlobalKey<FormState> formKey;
  final Widget child;
  final VoidCallback? onSubmit;

  const _IBasePage({
    Key? key,
    required this.emailController,
    required this.passwordController,
    required this.confirmPassController,
    required this.child,
    required this.autovalidateMode,
    required this.formKey,
    this.onSubmit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => StyledScaffold(
        body: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: SizedBox(
            height: 1.sh,
            width: 1.sw,
            child: Column(
              children: [
                StyledBackButton(),
                30.verticalSpace,
                Text(
                  'Forgot the password?',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineLarge,
                ),
                30.verticalSpace,
                Text(
                  'We’ll send you an email to reset\nyour password.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.labelLarge,
                ),
                20.verticalSpace,
                Form(
                  autovalidateMode: autovalidateMode,
                  key: formKey,
                  child: SizedBox(
                    width: 291.w,
                    child: Column(
                      children: [
                        StyledUnderlinedTextField(
                          hint: 'Email',
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          controller: emailController,
                          validator: (email) => validateEmail(email),
                        ),
                        StyledPasswordField(
                          hint: 'New Password',
                          textInputAction: TextInputAction.next,
                          controller: passwordController,
                          validator: (pass) => validatePassword(pass),
                        ),
                        StyledPasswordField(
                          hint: 'Confirm Password',
                          textInputAction: TextInputAction.done,
                          controller: confirmPassController,
                          validator: (confirmPass) => passwordController.text ==
                                  confirmPassController.text
                              ? null
                              : "Passwords do not match",
                          onFieldSubmitted:
                              onSubmit != null ? (_) => onSubmit!() : null,
                        ),
                      ],
                    ),
                  ),
                ),
                30.verticalSpace,
                child,
                Spacer(),
              ],
            ),
          ),
        ),
      );
}
