import 'package:flutter/material.dart';

import '../../../entities/entities.dart';
import '../../../use-cases/use_cases.dart';
import '../../widgets/widgets.dart';
import '../provider.dart';
import '../screens.dart';
import 'confirm_email_state.dart';
import 'confirm_email_view.dart';

class ConfirmEmailProvider
    extends ScreenProvider<ConfirmEmailState, ConfirmEmailView> {
  final Future<Failure?> Function(String email, String code)
      confirmVerification;
  final Future<Failure?> Function() resendConfirmation;
  final VoidCallback onPressedBack;
  final String email;
  final String password;

  const ConfirmEmailProvider({
    required this.confirmVerification,
    required this.resendConfirmation,
    required this.onPressedBack,
    required this.email,
    required this.password,
  }) : super();

  @override
  ConfirmEmailView build(BuildContext context, ConfirmEmailState state) =>
      ConfirmEmailView(
        onPressedBack: onPressedBack,
        onCompletedVerification: (code) {
          if (state.disposed) return;
          if (!state.loading) {
            state.loading = true;
            state.errorMessage = null;
            confirmVerification(email, code)
                .then(
              (value) async => !state.disposed && value == null
                  ? await loginUseCase
                      .login(email: email, password: password)
                      .then(
                        (either) => either.fold(
                          (session) => null,
                          (failure) => failure,
                        ),
                      )
                  : value,
            )
                .then(
              (result) {
                state.loading = false;
                if (result != null) {
                  state.errorMessage = result.message;
                } else if (!state.disposed) {
                  Navigator.of(context).pushAndRemoveUntil(
                    NoAnimationMaterialPageRoute(
                      builder: (context) => LoginProvider(),
                    ),
                    (_) => false,
                  );
                }
              },
            );
          }
        },
        onPressedResend: () {
          if (!state.loading) {
            state.loading = true;
            resendConfirmation().then(
              (result) {
                state.loading = false;
                if (result != null) {
                  state.errorMessage = result.message;
                }
              },
            );
          }
        },
        errorMessage: state.errorMessage,
        loading: state.loading,
      );

  @override
  ConfirmEmailState buildState() => ConfirmEmailState();
}
