import 'package:flutter/material.dart';

import '../../../common/validators.dart';
import '../../widgets/widgets.dart';
import '../provider.dart';
import '../screens.dart';
import 'register_page_one_state.dart';
import 'register_page_one_view.dart';

class RegisterPageOneProvider
    extends ScreenProvider<RegisterPageOneState, RegisterPageOneView> {
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? password;

  const RegisterPageOneProvider({
    this.firstName,
    this.lastName,
    this.email,
    this.password,
  }) : super();

  @override
  Future<void> init(BuildContext context, RegisterPageOneState state) async {
    if (firstName != null) {
      state.firstNameController.text = firstName!;
    }
    if (lastName != null) {
      state.lastNameController.text = lastName!;
    }
  }

  @override
  RegisterPageOneView build(BuildContext context, RegisterPageOneState state) =>
      RegisterPageOneView(
        formKey: state.formKey,
        autovalidateMode: state.autovalidateMode,
        validateFirstName: (value) => validateName(value),
        validateLastName: (value) => validateName(value),
        firstNameController: state.firstNameController,
        lastNameController: state.lastNameController,
        onPressedNext: () {
          if (state.formKey.currentState!.validate()) {
            Navigator.of(context).push(
              NoAnimationMaterialPageRoute(
                builder: (context) => RegisterPageTwoProvider(
                  firstName: state.firstNameController.text,
                  lastName: state.lastNameController.text,
                  email: email,
                  password: password,
                ),
              ),
            );
          } else {
            state.autovalidateMode = AutovalidateMode.always;
          }
        },
      );

  @override
  RegisterPageOneState buildState() => RegisterPageOneState();
}
