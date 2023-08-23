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
            createLoader: (_) => LoaderBloc(
              load: (email) => sendForgotPasswordRequest(
                email: email,
                apiInfo: apiInfo,
              ),
            ),
            listener: (context, controllers, loaderState, _) {
              switch (loaderState) {
                case LoaderLoadedState(data: final response):
                  switch (response) {
                    case SendForgotPasswordSuccess(user: final user):
                      Navigator.push(
                        context,
                        CupertinoPageRoute<void>(
                          builder: (context) => ConfirmEmailScreen(
                            apiInfo: apiInfo,
                            loginParams: LoginParams(
                              email: controllers.emailController.text,
                              password: controllers.newPasswordController.text,
                            ),
                            unauthenticatedSession: UnauthenticatedSession(
                              user: user,
                              apiInfo: apiInfo,
                            ),
                            resendConfirmationEmail: (session) =>
                                sendForgotPasswordRequest(
                              apiInfo: apiInfo,
                              email: controllers.emailController.text,
                            ).then(
                              (state) => state is SendForgotPasswordSuccess,
                            ),
                            confirmEmail: (session, code) =>
                                submitForgotPassword(
                              params: SubmitForgotPasswordParams(
                                email: controllers.emailController.text,
                                code: code,
                                newPassword:
                                    controllers.newPasswordController.text,
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
            builder: (context, controllers, loaderState, submit) {
              final formBloc = context.formBloc<ForgotPasswordControllers>();
              return PageView(
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
                            formBloc.formKey.currentState!.validate()
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
                        child: switch (loaderState) {
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
                ],
              );
            },
          ),
        ),
      );
}
