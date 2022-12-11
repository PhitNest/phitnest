import 'package:flutter/material.dart';

import '../provider.dart';
import 'confirm_email_state.dart';
import 'confirm_email_view.dart';

class ConfirmEmailProvider
    extends ScreenProvider<ConfirmEmailState, ConfirmEmailView> {
  final void Function(String code) onCompletedVerification;
  final VoidCallback onPressedResend;

  const ConfirmEmailProvider({
    required this.onCompletedVerification,
    required this.onPressedResend,
  }) : super();

  @override
  ConfirmEmailView build(BuildContext context, ConfirmEmailState state) =>
      ConfirmEmailView(
        onCompletedVerification: onCompletedVerification,
        onPressedResend: onPressedResend,
      );

  @override
  ConfirmEmailState buildState() => ConfirmEmailState();
}
