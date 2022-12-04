import 'package:flutter/material.dart';

import '../provider.dart';
import 'register_page_two_state.dart';
import 'register_page_two_view.dart';

class RegisterPageTwoProvider
    extends ScreenProvider<RegisterPageTwoState, RegisterPageTwoView> {
  @override
  RegisterPageTwoView build(BuildContext context, RegisterPageTwoState state) =>
      RegisterPageTwoView(
        keyboardVisible: state.keyboardVisible,
        onPressedNext: () {},
      );

  @override
  RegisterPageTwoState buildState() => RegisterPageTwoState();
}
