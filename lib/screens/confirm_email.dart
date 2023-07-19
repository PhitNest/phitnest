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

typedef ConfirmEmailFormBloc = FormBloc<ConfirmEmailControllers>;
typedef ConfirmEmailFormConsumer = FormConsumer<ConfirmEmailControllers>;
typedef ConfirmEmailLoaderBloc = LoaderBloc<String, bool>;
typedef ConfirmEmailLoaderConsumer = LoaderConsumer<String, bool>;
typedef ResendEmailLoaderBloc = LoaderBloc<void, bool>;
typedef ResendEmailLoaderConsumer = LoaderConsumer<void, bool>;

extension on BuildContext {
  ConfirmEmailFormBloc get confirmEmailFormBloc => BlocProvider.of(this);
  ConfirmEmailLoaderBloc get confirmEmailLoaderBloc => loader();
  ResendEmailLoaderBloc get resendEmailLoaderBloc => loader();
  LoginLoaderBloc get loginLoaderBloc => loader();
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
        body: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => ConfirmEmailFormBloc(ConfirmEmailControllers()),
            ),
            BlocProvider(
              create: (_) => ConfirmEmailLoaderBloc(
                load: (code) => confirmEmail(
                  unauthenticatedSession,
                  code,
                ),
              ),
            ),
            BlocProvider(
              create: (_) => ResendEmailLoaderBloc(
                load: (_) => resendConfirmationEmail(
                  unauthenticatedSession,
                ),
              ),
            ),
            BlocProvider(
              create: (_) => LoginLoaderBloc(
                load: (params) => login(
                  apiInfo: unauthenticatedSession.apiInfo,
                  params: params,
                ),
              ),
            ),
          ],
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
                  child: ConfirmEmailFormConsumer(
                    listener: (context, formState) {},
                    builder: (context, formState) {
                      formBuilder(BuildContext context, bool loading) => Form(
                            key: context.confirmEmailFormBloc.formKey,
                            child: Column(
                              children: [
                                StyledVerificationField(
                                  controller: context.confirmEmailFormBloc
                                      .controllers.codeController,
                                  focusNode: context.confirmEmailFormBloc
                                      .controllers.focusNode,
                                  onChanged: (value) {},
                                  onCompleted: (value) {
                                    if (!loading) {
                                      context.confirmEmailLoaderBloc
                                          .add(LoaderLoadEvent(value));
                                    }
                                  },
                                ),
                                16.verticalSpace,
                                ...loading
                                    ? [const CircularProgressIndicator()]
                                    : [
                                        ElevatedButton(
                                          onPressed: () => context
                                              .confirmEmailFormBloc
                                              .submit(
                                            onAccept: () => context
                                                .confirmEmailLoaderBloc
                                                .add(
                                              LoaderLoadEvent(
                                                context
                                                    .confirmEmailFormBloc
                                                    .controllers
                                                    .codeController
                                                    .text,
                                              ),
                                            ),
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
                              ],
                            ),
                          );
                      return LoginLoaderConsumer(
                        listener: (context, loginState) {
                          switch (loginState) {
                            case LoaderLoadedState(data: final response):
                              switch (response) {
                                case LoginSuccess():
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    CupertinoPageRoute<void>(
                                      builder: (context) => HomeScreen(
                                        apiInfo: unauthenticatedSession.apiInfo,
                                      ),
                                    ),
                                    (_) => false,
                                  );
                                case LoginFailureResponse(
                                    message: final message
                                  ):
                                  StyledBanner.show(
                                      message: message, error: true);
                                  context.confirmEmailFormBloc.controllers
                                      .codeController
                                      .clear();
                              }
                            default:
                          }
                        },
                        builder: (context, loginState) => switch (loginState) {
                          LoaderLoadingState() => formBuilder(context, true),
                          _ => ConfirmEmailLoaderConsumer(
                              listener: (context, confirmEmailState) {
                                switch (confirmEmailState) {
                                  case LoaderLoadedState(data: final confirmed):
                                    if (confirmed) {
                                      context.loginLoaderBloc
                                          .add(LoaderLoadEvent(loginParams));
                                    } else {
                                      StyledBanner.show(
                                        message: 'Invalid code',
                                        error: true,
                                      );
                                      context.confirmEmailFormBloc.controllers
                                          .codeController
                                          .clear();
                                    }
                                  default:
                                }
                              },
                              builder: (context, confirmEmailState) =>
                                  switch (confirmEmailState) {
                                LoaderLoadingState() =>
                                  formBuilder(context, true),
                                _ => ResendEmailLoaderConsumer(
                                    listener: (context, resendEmailState) {
                                      switch (resendEmailState) {
                                        case LoaderLoadedState(
                                            data: final sent
                                          ):
                                          if (sent) {
                                            StyledBanner.show(
                                              message:
                                                  'Confirmation email sent',
                                              error: false,
                                            );
                                          } else {
                                            StyledBanner.show(
                                              message: 'Failed to resend '
                                                  'confirmation email',
                                              error: true,
                                            );
                                          }
                                        default:
                                      }
                                    },
                                    builder: (context, resendEmailState) =>
                                        switch (resendEmailState) {
                                      LoaderLoadingState() =>
                                        formBuilder(context, true),
                                      _ => formBuilder(context, false),
                                    },
                                  ),
                              },
                            ),
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
