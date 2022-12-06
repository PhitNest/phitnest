import 'package:flutter/material.dart';

import '../../widgets/widgets.dart';
import '../provider.dart';
import '../screens.dart';
import 'register_page_one_state.dart';
import 'register_page_one_view.dart';

class RegisterPageOneProvider
    extends ScreenProvider<RegisterPageOneState, RegisterPageOneView> {
  const RegisterPageOneProvider() : super();

  @override
  RegisterPageOneView build(BuildContext context, RegisterPageOneState state) =>
      RegisterPageOneView(
        firstNameController: state.firstNameController,
        lastNameController: state.lastNameController,
        onPressedNext: () => Navigator.of(context).push(
          NoAnimationMaterialPageRoute(
            builder: (context) => RegisterPageTwoProvider(),
          ),
        ),
      );

  @override
  RegisterPageOneState buildState() => RegisterPageOneState();
}
