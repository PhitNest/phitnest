import 'package:flutter/material.dart';

import '../../widgets/widgets.dart';
import '../provider.dart';
import '../screens.dart';
import 'register_page_two_state.dart';
import 'register_page_two_view.dart';

class RegisterPageTwoProvider
    extends ScreenProvider<RegisterPageTwoState, RegisterPageTwoView> {
  const RegisterPageTwoProvider() : super();

  @override
  RegisterPageTwoView build(BuildContext context, RegisterPageTwoState state) =>
      RegisterPageTwoView(
        onPressedNext: () => Navigator.of(context).push(
          NoAnimationMaterialPageRoute(
            builder: (context) => PhotoInstructionProvider(),
          ),
        ),
      );

  @override
  RegisterPageTwoState buildState() => RegisterPageTwoState();
}
