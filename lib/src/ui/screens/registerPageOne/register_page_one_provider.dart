import 'package:flutter/material.dart';

import '../provider.dart';
import 'register_page_one_state.dart';
import 'register_page_one_view.dart';

class RegisterPageOneProvider
    extends ScreenProvider<RegisterPageOneState, RegisterPageOneView> {
  @override
  RegisterPageOneView build(BuildContext context, RegisterPageOneState state) =>
      RegisterPageOneView(
        firstNameController: state.firstNameController,
        lastNameController: state.lastNameController,
        keyboardVisible: state.keyboardVisible,
        onPressedNext: () {},
      );

  @override
  RegisterPageOneState buildState() => RegisterPageOneState();
}
