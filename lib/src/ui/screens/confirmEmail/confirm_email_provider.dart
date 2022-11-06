import 'package:flutter/src/widgets/framework.dart';

import '../provider.dart';
import 'confirm_email_state.dart';
import 'confirm_email_view.dart';

class ConfirmEmailProvider
    extends ScreenProvider<ConfirmEmailState, ConfirmEmailView> {
  @override
  ConfirmEmailView build(BuildContext context, ConfirmEmailState state) =>
      ConfirmEmailView();

  @override
  ConfirmEmailState buildState() => ConfirmEmailState();
}
