part of 'forgot_password.dart';

final class ForgotPasswordScreen extends StatelessWidget {
  final ApiInfo apiInfo;

  const ForgotPasswordScreen({
    super.key,
    required this.apiInfo,
  }) : super();

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 40.w),
          child: FormProvider<ForgotPasswordControllers, String,
              SendForgotPasswordResponse>(
            createControllers: (_) => ForgotPasswordControllers(),
            load: (email) => sendForgotPasswordRequest(
              email: email,
              apiInfo: apiInfo,
            ),
            formBuilder: (context, controllers, consumer) => PageView(
              controller: controllers.pageController,
              children: [
                Column(
                  children: [
                    64.verticalSpace,
                    Text(
                      'Forgot Password?',
                      style: theme.textTheme.bodyLarge,
                    ),
                    32.verticalSpace,
                    Text(
                      'Enter your email address',
                      style: theme.textTheme.bodyMedium,
                    ),
                    16.verticalSpace,
                    StyledUnderlinedTextField(
                      hint: 'Email',
                      controller: controllers.emailController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) =>
                          BlocProvider.of<FormBloc<ForgotPasswordControllers>>(
                                      context)
                                  .formKey
                                  .currentState!
                                  .validate()
                              ? controllers.pageController.nextPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                )
                              : {},
                      validator: EmailValidator.validateEmail,
                    ),
                    23.verticalSpace,
                    StyledOutlineButton(
                      onPress: () => controllers.pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      ),
                      text: 'NEXT',
                    ),
                  ],
                ),
                consumer(
                  listener: (context, state, _) {
                    switch (state) {
                      case LoaderLoadedState(data: final response):
                        switch (response) {
                          case SendForgotPasswordSuccess(user: final user):
                            Navigator.push(
                              context,
                              CupertinoPageRoute<void>(
                                builder: (context) => ConfirmEmailScreen(
                                  loginParams: LoginParams(
                                    email: controllers.emailController.text,
                                    password:
                                        controllers.newPasswordController.text,
                                  ),
                                  unauthenticatedSession:
                                      UnauthenticatedSession(
                                    user: user,
                                    apiInfo: apiInfo,
                                  ),
                                  resendConfirmationEmail: (session) =>
                                      sendForgotPasswordRequest(
                                    apiInfo: apiInfo,
                                    email: controllers.emailController.text,
                                  ).then(
                                    (state) =>
                                        state is SendForgotPasswordSuccess,
                                  ),
                                  confirmEmail: (session, code) =>
                                      submitForgotPassword(
                                    params: SubmitForgotPasswordParams(
                                      email: controllers.emailController.text,
                                      code: code,
                                      newPassword: controllers
                                          .newPasswordController.text,
                                    ),
                                    session: session,
                                  ).then((state) => state == null),
                                ),
                              ),
                            );
                          case SendForgotPasswordFailureResponse(
                              message: final message
                            ):
                            StyledBanner.show(
                              message: message,
                              error: true,
                            );
                        }
                      default:
                    }
                  },
                  builder: (context, state, submit) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      64.verticalSpace,
                      Text(
                        'Forgot Password?',
                        style: theme.textTheme.bodyLarge,
                      ),
                      32.verticalSpace,
                      Text(
                        'Enter your new password',
                        style: theme.textTheme.bodyMedium,
                      ),
                      16.verticalSpace,
                      StyledPasswordField(
                        hint: 'New Password',
                        controller: controllers.newPasswordController,
                        textInputAction: TextInputAction.next,
                        validator: validatePassword,
                      ),
                      16.verticalSpace,
                      StyledPasswordField(
                        hint: 'Confirm Password',
                        controller: controllers.confirmPasswordController,
                        textInputAction: TextInputAction.done,
                        validator: (pass) =>
                            validatePassword(pass) ??
                            (pass != controllers.newPasswordController.text
                                ? 'Passwords do not match'
                                : null),
                        onFieldSubmitted: (_) =>
                            submit(controllers.emailController.text),
                      ),
                      23.verticalSpace,
                      Center(
                        child: switch (state) {
                          LoaderLoadingState() =>
                            const CircularProgressIndicator(),
                          _ => ElevatedButton(
                              onPressed: () =>
                                  submit(controllers.emailController.text),
                              child: Text(
                                'RESET PASSWORD',
                                style: theme.textTheme.bodySmall,
                              ),
                            ),
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
