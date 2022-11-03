import 'package:flutter/material.dart';
import 'package:phitnest_mobile/src/utils/utils.dart';

import '../../common/widgets.dart';
import '../screens.dart';
import '../provider.dart';
import 'apology_state.dart';
import 'apology_view.dart';

class ApologyProvider extends ScreenProvider<ApologyState, ApologyView> {
  @override
  ApologyView build(BuildContext context, ApologyState state) => ApologyView(
      autovalidateMode: state.validateMode,
      onPressedContactUs: () => Navigator.pushAndRemoveUntil(
          context,
          NoAnimationMaterialPageRoute(builder: (_) => ContactUsProvider()),
          (_) => false),
      onPressedSubmit: () => validateForm(context, state),
      nameController: state.nameController,
      emailController: state.emailController,
      validateFirstName: validateFirstName,
      validateEmail: validateEmail,
      keyboardVisible: state.keyboardVisible,
      formKey: state.formKey);

  @override
  ApologyState buildState() => ApologyState();

  validateForm(BuildContext context, ApologyState state) {
    if (!state.formKey.currentState!.validate()) {
      state.validateMode = AutovalidateMode.always;
    } else {
      Navigator.pushAndRemoveUntil(
          context,
          NoAnimationMaterialPageRoute(
              builder: (_) =>
                  ThankYouProvider(name: state.nameController.text)),
          (_) => false);
    }
  }
}