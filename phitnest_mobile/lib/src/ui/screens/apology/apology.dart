import 'package:flutter/material.dart';
import 'package:phitnest_mobile/src/utils/utils.dart';

import '../../../routes.dart';
import '../screen.dart';
import 'apology_state.dart';
import 'apology_view.dart';

class ApologyScreen extends Screen<ApologyState, ApologyView> {
  @override
  ApologyView build(BuildContext context, ApologyState state) => ApologyView(autovalidateMode: state.validateMode,
      onPressedContactUs: () =>
          Navigator.pushNamedAndRemoveUntil(context, kContactUs, (_) => false),
      onPressedSubmit: () =>validateForm(context, state),
      nameController: state.nameController,
      emailController: state.emailController,
      validateFirstName: validateFirstName,
      validateEmail: validateEmail,
      formKey: state.formKey
      );

  @override
  ApologyState buildState() => ApologyState();

  validateForm(BuildContext context, ApologyState state) {
    if (!state.formKey.currentState!.validate()) {
      state.validateMode = AutovalidateMode.always;
    }
    else {
      Navigator.pushNamedAndRemoveUntil(
          context, kThankYou, (_) => false,
          arguments: state.nameController.text);
    }
  }
}
