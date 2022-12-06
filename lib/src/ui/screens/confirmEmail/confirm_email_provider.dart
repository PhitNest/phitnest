import 'package:flutter/material.dart';

import '../provider.dart';
import 'confirm_email_state.dart';
import 'confirm_email_view.dart';

class ConfirmEmailProvider
    extends ScreenProvider<ConfirmEmailState, ConfirmEmailView> {
  const ConfirmEmailProvider() : super();

  @override
  ConfirmEmailView build(BuildContext context, ConfirmEmailState state) =>
      ConfirmEmailView(
        onCompletedVerification: (code) {},
        onPressedNext: () {},
      );

  @override
  ConfirmEmailState buildState() => ConfirmEmailState();
}
