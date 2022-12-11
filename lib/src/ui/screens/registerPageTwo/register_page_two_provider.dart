import 'package:flutter/material.dart';

import '../../../common/validators.dart';
import '../../widgets/widgets.dart';
import '../provider.dart';
import '../screens.dart';
import 'register_page_two_state.dart';
import 'register_page_two_view.dart';

class RegisterPageTwoProvider
    extends ScreenProvider<RegisterPageTwoState, RegisterPageTwoView> {
  final String firstName;
  final String lastName;
  final String? email;
  final String? password;
  final String? errorMessage;

  const RegisterPageTwoProvider({
    required this.firstName,
    required this.lastName,
    this.email,
    this.password,
    this.errorMessage,
  }) : super();

  @override
  Future<void> init(BuildContext context, RegisterPageTwoState state) async {
    if (email != null) {
      state.emailController.text = email!;
    }
    if (password != null) {
      state.passwordController.text = password!;
    }
    if (errorMessage != null) {
      state.errorMessage = errorMessage;
      state.autovalidateMode = AutovalidateMode.always;
    }
  }

  @override
  RegisterPageTwoView build(BuildContext context, RegisterPageTwoState state) =>
      RegisterPageTwoView(
        onPressedBack: () => Navigator.of(context)
          ..pop()
          ..pop()
          ..push(
            NoAnimationMaterialPageRoute(
              builder: (context) => RegisterPageOneProvider(
                email: state.emailController.text,
                password: state.passwordController.text,
                firstName: firstName,
                lastName: lastName,
              ),
            ),
          ),
        onTapEmail: () {
          state.errorMessage = null;
          Future.delayed(
            const Duration(milliseconds: 600),
            () => state.onFocusEmail(true),
          );
        },
        onTapPassword: () {
          state.errorMessage = null;
          Future.delayed(
            const Duration(milliseconds: 600),
            () => state.onFocusPassword(true),
          );
        },
        onTapConfirmPassword: () {
          state.errorMessage = null;
          Future.delayed(
            const Duration(milliseconds: 600),
            () => state.onFocusConfirmPassword(true),
          );
        },
        emailFocus: state.emailFocus,
        passwordFocus: state.passwordFocus,
        confirmPasswordFocus: state.confirmPasswordFocus,
        scrollController: state.scrollController,
        formKey: state.formKey,
        autovalidateMode: state.autovalidateMode,
        validateEmail: (value) => validateEmail(value),
        validatePassword: (value) => validatePassword(value),
        validateConfirmPassword: (value) =>
            state.passwordController.text == value
                ? null
                : "Passwords don't match.",
        emailController: state.emailController,
        passwordController: state.passwordController,
        confirmPasswordController: state.confirmPasswordController,
        errorMessage: state.errorMessage,
        onPressedNext: () {
          if (state.formKey.currentState!.validate()) {
            Navigator.of(context).push(
              NoAnimationMaterialPageRoute(
                builder: (context) => PhotoInstructionProvider(
                  firstName: firstName,
                  lastName: lastName,
                  email: state.emailController.text,
                  password: state.passwordController.text,
                ),
              ),
            );
          } else {
            state.autovalidateMode = AutovalidateMode.always;
          }
        },
      );

  @override
  RegisterPageTwoState buildState() => RegisterPageTwoState();
}
