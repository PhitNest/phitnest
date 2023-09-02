import 'package:core/core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ui/ui.dart';

import '../home/home.dart';
import 'widgets/widgets.dart';

part 'bloc.dart';

void _handleResendStateChanged(
    BuildContext context, LoaderState<String?> loaderState) {
  switch (loaderState) {
    case LoaderLoadedState(data: final error):
      if (error == null) {
        StyledBanner.show(
          message: 'Email resent',
          error: false,
        );
      } else {
        StyledBanner.show(
          message: error,
          error: true,
        );
      }
    default:
  }
}

final class VerificationPage extends StatelessWidget {
  final LoginParams loginParams;
  final UnauthenticatedSession unauthenticatedSession;
  final Future<String?> Function(UnauthenticatedSession session) resend;
  final Future<String?> Function(UnauthenticatedSession session, String code)
      confirm;

  const VerificationPage({
    super.key,
    required this.loginParams,
    required this.unauthenticatedSession,
    required this.resend,
    required this.confirm,
  }) : super();

  void handleConfirmStateChanged(
    BuildContext context,
    VerificationControllers controllers,
    LoaderState<LoginResponse?> loaderState,
  ) {
    switch (loaderState) {
      case LoaderLoadedState(data: final response):
        if (response != null) {
          switch (response) {
            case LoginSuccess():
              Navigator.pushAndRemoveUntil(
                context,
                CupertinoPageRoute<void>(
                  builder: (_) => const HomePage(),
                ),
                (_) => false,
              );
            case LoginFailureResponse(message: final message):
              StyledBanner.show(message: message, error: true);
              controllers.codeController.clear();
          }
        } else {
          StyledBanner.show(message: 'Invalid code', error: true);
          controllers.codeController.clear();
        }
      default:
    }
  }

  Future<LoginResponse> confirmAndLogin(String code) async {
    final error = await confirm(unauthenticatedSession, code);
    if (error == null) {
      return await login(loginParams);
    } else {
      return LoginUnknownResponse(message: error);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 32.w),
          child: SingleChildScrollView(
            child: BlocProvider(
              create: (_) => ResendLoaderBloc(load: resend),
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
                    child: verificationForm(
                      confirmAndLogin,
                      (context, controllers, submit) => LoaderConsumer(
                        listener: (context, loaderState) =>
                            handleConfirmStateChanged(
                                context, controllers, loaderState),
                        builder: (context, loaderState) => ResendLoaderConsumer(
                          listener: _handleResendStateChanged,
                          builder: (context, resendState) => Column(
                            children: [
                              VerificationField(
                                controller: controllers.codeController,
                                focusNode: controllers.focusNode,
                                onChanged: (value) {},
                                onCompleted: switch (resendState) {
                                  LoaderLoadingState() => (_) {},
                                  _ => (code) {
                                      submit(code, loaderState);
                                      final currentFocus =
                                          FocusScope.of(context);
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
                                    LoaderLoadingState() => [const Loader()],
                                    _ => [
                                        ElevatedButton(
                                          onPressed: () => submit(
                                            controllers.codeController.text,
                                            loaderState,
                                          ),
                                          child: Text(
                                            'CONFIRM',
                                            style: theme.textTheme.bodySmall,
                                          ),
                                        ),
                                        ElevatedButton(
                                          onPressed: () => context
                                              .resendEmailLoaderBloc
                                              .add(LoaderLoadEvent(
                                                  unauthenticatedSession)),
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
        ),
      );
}
