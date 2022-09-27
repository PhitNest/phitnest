import 'package:flutter/material.dart';

import '../../../routes.dart';
import '../screen.dart';
import 'apology_state.dart';
import 'apology_view.dart';

class ApologyScreen extends Screen<ApologyState, ApologyView> {
  @override
  ApologyView build(BuildContext context, ApologyState state) => ApologyView(autovalidateMode: state.validateMode,
      onPressedContactUs: () =>
          Navigator.pushNamedAndRemoveUntil(context, kContactUs, (_) => false),
      onPressedSubmit: () => Navigator.pushNamedAndRemoveUntil(
          context, kThankYou, (_) => false,
          arguments: state.nameController.text),
      nameController: state.nameController,
      emailController: state.emailController);

  @override
  ApologyState buildState() => ApologyState();
}
