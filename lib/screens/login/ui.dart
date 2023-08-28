part of 'login.dart';

final class LoginScreen extends StatelessWidget {
  final ApiInfo apiInfo;

  const LoginScreen({
    super.key,
    required this.apiInfo,
  }) : super();

  static LoginParams _params(LoginControllers controllers) => LoginParams(
        email: controllers.emailController.text,
        password: controllers.passwordController.text,
      );

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 40.w),
          child: FormProvider<LoginControllers, LoginParams, LoginResponse>(
            createLoader: (_) => LoaderBloc(
              load: (params) => login(
                params: params,
                apiInfo: apiInfo,
              ),
            ),
            createControllers: (_) => LoginControllers(),
            createConsumer: (context, controllers, submit) => LoaderConsumer(
              listener: (context, loaderState) {
                switch (loaderState) {
                  case LoaderLoadedState(data: final response):
                    switch (response) {
                      case LoginSuccess():
                        Navigator.pushAndRemoveUntil(
                          context,
                          CupertinoPageRoute<void>(
                            builder: (context) => HomeScreen(apiInfo: apiInfo),
                          ),
                          (_) => false,
                        );
                      case LoginConfirmationRequired(user: final user):
                        Navigator.pushReplacement(
                          context,
                          CupertinoPageRoute<void>(
                            builder: (context) => ConfirmEmailScreen(
                              unauthenticatedSession: UnauthenticatedSession(
                                apiInfo: apiInfo,
                                user: user,
                              ),
                              resendConfirmationEmail: (session) =>
                                  resendConfirmationEmail(
                                user: session.user,
                              ),
                              confirmEmail: (session, code) => confirmEmail(
                                user: session.user,
                                code: code,
                              ),
                              apiInfo: apiInfo,
                              loginParams: _params(controllers),
                            ),
                          ),
                        );
                      case LoginFailure(message: final message) ||
                            LoginUnknownResponse(message: final message) ||
                            LoginChangePasswordRequired(message: final message):
                        StyledBanner.show(
                          message: message,
                          error: true,
                        );
                    }
                  default:
                }
              },
              builder: (context, loaderState) {
                return Column(
                  children: [
                    120.verticalSpace,
                    Text(
                      'Login',
                      style: theme.textTheme.bodyLarge,
                    ),
                    70.verticalSpace,
                    StyledUnderlinedTextField(
                      hint: 'Email',
                      controller: controllers.emailController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      validator: EmailValidator.validateEmail,
                    ),
                    24.verticalSpace,
                    StyledPasswordField(
                      hint: 'Password',
                      controller: controllers.passwordController,
                      textInputAction: TextInputAction.done,
                      validator: validatePassword,
                      onFieldSubmitted: (_) =>
                          submit(_params(controllers), loaderState),
                    ),
                    Row(
                      children: [
                        TextButton(
                          onPressed: () {
                            context.loginBloc.add(const LoaderCancelEvent());
                            Navigator.push(
                              context,
                              CupertinoPageRoute<void>(
                                builder: (context) => ForgotPasswordScreen(
                                  apiInfo: apiInfo,
                                ),
                              ),
                            );
                          },
                          child: Text(
                            'Forgot Password?',
                            style: theme.textTheme.bodySmall!
                                .copyWith(fontStyle: FontStyle.normal),
                          ),
                        ),
                      ],
                    ),
                    8.verticalSpace,
                    switch (loaderState) {
                      LoaderLoadingState() => const CircularProgressIndicator(),
                      LoaderInitialState() ||
                      LoaderLoadedState() =>
                        ElevatedButton(
                          onPressed: () =>
                              submit(_params(controllers), loaderState),
                          child: Text(
                            'LOGIN',
                            style: theme.textTheme.bodySmall,
                          ),
                        ),
                    },
                    32.verticalSpace,
                    RichText(
                      text: TextSpan(
                        text: "Don't have an account?",
                        style: theme.textTheme.bodySmall,
                        children: [
                          TextSpan(
                            text: 'Register',
                            style: theme.textTheme.bodySmall!.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                context.loginBloc
                                    .add(const LoaderCancelEvent());
                                Navigator.of(context).push(
                                  CupertinoPageRoute<void>(
                                    builder: (context) => RegisterScreen(
                                      apiInfo: apiInfo,
                                    ),
                                  ),
                                );
                              },
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      );
}
