import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phitnest_core/core.dart';

import '../widgets/widgets.dart';
import 'home/ui.dart';

class ConfirmEmailControllers extends FormControllers {
  final focusNode = FocusNode();
  final codeController = TextEditingController();

  @override
  void dispose() {
    codeController.dispose();
    focusNode.dispose();
  }
}

typedef ResendEmailLoaderBloc = LoaderBloc<void, bool>;
typedef ResendEmailLoaderConsumer = LoaderConsumer<void, bool>;

extension on BuildContext {
  ResendEmailLoaderBloc get resendEmailLoaderBloc => loader();
}

final class ConfirmEmailScreen extends StatelessWidget {
  final LoginParams loginParams;
  final UnauthenticatedSession unauthenticatedSession;
  final Future<bool> Function(UnauthenticatedSession session)
      resendConfirmationEmail;
  final Future<bool> Function(UnauthenticatedSession session, String code)
      confirmEmail;

  const ConfirmEmailScreen({
    super.key,
    required this.loginParams,
    required this.unauthenticatedSession,
    required this.resendConfirmationEmail,
    required this.confirmEmail,
  }) : super();

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
                    load: (code) =>
                        confirmEmail(unauthenticatedSession, code).then(
                      (confirmed) => confirmed
                          ? login(
                              apiInfo: unauthenticatedSession.apiInfo,
                              params: loginParams,
                            )
                          : null,
                    ),
                    createControllers: (_) => ConfirmEmailControllers(),
                    formBuilder: (context, controllers, consumer) =>
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
                      builder: (context, resendState) => consumer(
                        listener: (context, state, _) {
                          switch (state) {
                            case LoaderLoadedState(data: final response):
                              if (response != null) {
                                switch (response) {
                                  case LoginSuccess():
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      CupertinoPageRoute<void>(
                                        builder: (context) => HomeScreen(
                                          apiInfo:
                                              unauthenticatedSession.apiInfo,
                                        ),
                                      ),
                                      (_) => false,
                                    );
                                  case LoginFailureResponse(
                                      message: final message
                                    ):
                                    StyledBanner.show(
                                        message: message, error: true);
                                }
                              } else {
                                StyledBanner.show(
                                    message: 'Invalid code', error: true);
                              }
                              controllers.codeController.clear();
                            default:
                          }
                        },
                        builder: (context, state, submit) => Column(
                          children: [
                            StyledVerificationField(
                              controller: controllers.codeController,
                              focusNode: controllers.focusNode,
                              onChanged: (value) {},
                              onCompleted: switch (resendState) {
                                LoaderLoadingState() => (_) {},
                                _ => submit
                              },
                            ),
                            16.verticalSpace,
                            ...switch (state) {
                              LoaderLoadingState() => [
                                  const CircularProgressIndicator()
                                ],
                              _ => switch (resendState) {
                                  LoaderLoadingState() => [
                                      const CircularProgressIndicator()
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
                ),
              ],
            ),
          ),
        ),
      );
}
