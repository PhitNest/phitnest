part of login_page;

abstract class _LoginPageBase extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final GlobalKey<FormState> formKey;
  final double keyboardHeight;
  final AutovalidateMode autovalidateMode;
  final VoidCallback? onSubmit;
  final Widget child;
  final VoidCallback onPressedForgotPassword;
  final VoidCallback onPressedRegister;
  final Set<Tuple2<String, String>> invalidCredentials;

  const _LoginPageBase({
    Key? key,
    required this.emailController,
    required this.passwordController,
    required this.formKey,
    required this.keyboardHeight,
    required this.autovalidateMode,
    required this.child,
    required this.onPressedForgotPassword,
    required this.onPressedRegister,
    required this.invalidCredentials,
    this.onSubmit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => StyledScaffold(
        body: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: SizedBox(
            height: 1.sh,
            width: double.infinity,
            child: Column(
              children: [
                (120 - keyboardHeight / 4).verticalSpace,
                Image.asset(
                  Assets.logo.path,
                  width: 61.59.w,
                ),
                25.verticalSpace,
                Text(
                  'PhitNest is Better Together',
                  style: theme.textTheme.headlineMedium,
                ),
                40.verticalSpace,
                SizedBox(
                  width: 291.w,
                  child: Form(
                    key: formKey,
                    autovalidateMode: autovalidateMode,
                    child: Column(
                      children: [
                        StyledUnderlinedTextField(
                          controller: emailController,
                          hint: 'Email',
                          errorMaxLines: 1,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          validator: (value) =>
                              validateEmail(value) ??
                              (invalidCredentials.any((credentials) =>
                                      credentials.value1 == value &&
                                      credentials.value2 ==
                                          passwordController.text)
                                  ? 'Invalid email/password'
                                  : null),
                        ),
                        StyledPasswordField(
                          controller: passwordController,
                          hint: 'Password',
                          textInputAction: TextInputAction.done,
                          validator: (value) => validatePassword(value),
                          onFieldSubmitted:
                              onSubmit != null ? (value) => onSubmit!() : null,
                        ),
                      ],
                    ),
                  ),
                ),
                16.verticalSpace,
                child,
                Spacer(),
                StyledUnderlinedTextButton(
                  text: 'FORGOT PASSWORD?',
                  onPressed: onPressedForgotPassword,
                ),
                StyledUnderlinedTextButton(
                  text: 'REGISTER',
                  onPressed: onPressedRegister,
                ),
                48.verticalSpace,
              ],
            ),
          ),
        ),
      );
}
