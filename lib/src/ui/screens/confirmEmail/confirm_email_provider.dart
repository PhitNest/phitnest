import 'package:flutter/material.dart';

import '../../../entities/entities.dart';
import '../provider.dart';
import 'confirm_email_state.dart';
import 'confirm_email_view.dart';

class ConfirmEmailProvider
    extends ScreenProvider<ConfirmEmailState, ConfirmEmailView> {
  final Future<Failure?> Function(String code) confirmVerification;
  final Future<Failure?> Function() resendConfirmation;
  final VoidCallback onPressedBack;

  const ConfirmEmailProvider({
    required this.confirmVerification,
    required this.resendConfirmation,
    required this.onPressedBack,
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
            confirmVerification(code).then(
              (result) {
                state.loading = false;
                if (result != null) {
                  state.errorMessage = result.message;
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
