part of 'confirm_email.dart';

final class ConfirmEmailScreen extends StatelessWidget {
  final LoginParams loginParams;
  final UnauthenticatedSession unauthenticatedSession;
  final Future<bool> Function(UnauthenticatedSession session)
      resendConfirmationEmail;
  final Future<bool> Function(UnauthenticatedSession session, String code)
      confirmEmail;
  final ApiInfo apiInfo;

  const ConfirmEmailScreen({
    super.key,
    required this.loginParams,
    required this.unauthenticatedSession,
    required this.resendConfirmationEmail,
    required this.confirmEmail,
    required this.apiInfo,
  }) : super();

  Future<LoginResponse?> submit(String code) async {
    final confirmed = await confirmEmail(unauthenticatedSession, code);
    if (confirmed) {
      return await login(
        apiInfo: unauthenticatedSession.apiInfo,
        params: loginParams,
      );
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: BlocProvider(
          create: (_) => ResendEmailLoaderBloc(
            load: (_) => resendConfirmationEmail(
              unauthenticatedSession,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.w),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  120.verticalSpace,
                  Text(
                    'Verify your email',
                    style: theme.textTheme.bodyLarge,
                  ),
                  52.verticalSpace,
                  Center(
                    child: FormProvider<ConfirmEmailControllers, String,
                        LoginResponse?>(
                      createLoader: (_) => ConfirmEmailBloc(load: submit),
                      createControllers: (_) => ConfirmEmailControllers(),
                      listener: (context, controllers, loaderState, _) {
                        switch (loaderState) {
                          case LoaderLoadedState(data: final response):
                            if (response != null) {
                              switch (response) {
                                case LoginSuccess():
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    CupertinoPageRoute<void>(
                                      builder: (context) => HomeScreen(
                                        apiInfo: apiInfo,
                                      ),
                                    ),
                                    (_) => false,
                                  );
                                case LoginFailureResponse(
                                    message: final message
                                  ):
                                  StyledBanner.show(
                                      message: message, error: true);
                                  controllers.codeController.clear();
                              }
                            } else {
                              StyledBanner.show(
                                  message: 'Invalid code', error: true);
                              controllers.codeController.clear();
                            }
                          default:
                        }
                      },
                      builder: (_, controllers, loaderState, submit) =>
                          ResendEmailLoaderConsumer(
                        listener: (context, resendState) {
                          switch (resendState) {
                            case LoaderLoadedState(data: final resent):
                              if (resent) {
                                StyledBanner.show(
                                  message: 'Email resent',
                                  error: false,
                                );
                              } else {
                                StyledBanner.show(
                                  message: 'Email not resent',
                                  error: true,
                                );
                              }
                            default:
                          }
                        },
                        builder: (context, resendState) => Column(
                          children: [
                            StyledVerificationField(
                              controller: controllers.codeController,
                              focusNode: controllers.focusNode,
                              onChanged: (value) {},
                              onCompleted: switch (resendState) {
                                LoaderLoadingState() => (_) {},
                                _ => (code) {
                                    submit(code);
                                    final currentFocus = FocusScope.of(context);
                                    if (!currentFocus.hasPrimaryFocus) {
                                      currentFocus.unfocus();
                                    }
                                  }
                              },
                            ),
                            16.verticalSpace,
                            ...switch (loaderState) {
                              LoaderLoadingState() => [const Loader()],
                              _ => switch (resendState) {
                                  LoaderLoadingState() => [
                                      const Loader(),
                                    ],
                                  _ => [
                                      ElevatedButton(
                                        onPressed: () => submit(
                                          controllers.codeController.text,
                                        ),
                                        child: Text(
                                          'CONFIRM',
                                          style: theme.textTheme.bodySmall,
                                        ),
                                      ),
                                      ElevatedButton(
                                        onPressed: () => context
                                            .resendEmailLoaderBloc
                                            .add(const LoaderLoadEvent(null)),
                                        child: Text(
                                          'RESEND',
                                          style: theme.textTheme.bodySmall,
                                        ),
                                      ),
                                    ],
                                },
                            },
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
