import 'package:flutter/material.dart';

import './forgot_password_state.dart';
import './forgot_password_view.dart';
import '../../../common/validators.dart';
import '../../../use-cases/use_cases.dart';
import '../provider.dart';

class ForgotPasswordProvider
    extends ScreenProvider<ForgotPasswordState, ForgotPasswordView> {
  const ForgotPasswordProvider() : super();

  @override
  ForgotPasswordView build(BuildContext context, ForgotPasswordState state) =>
      ForgotPasswordView(
        scrollController: state.scrollController,
        emailAddressController: state.emailAddressController,
        newPassController: state.newPassController,
        rewriteNewPassController: state.rewriteNewPassController,
        errorMessage: state.errorMessage,
        loading: state.loading,
        formKey: state.formKey,
        autoValidateMode: state.autoValidateMode,
        validateEmail: (value) => validateEmail(value),
        onPressedSubmit: () {
          state.loading = true;
          state.errorMessage = null;
          if (state.formKey.currentState!.validate()) {
            forgotPasswordUseCase
                .forgotPassword(state.emailAddressController.text.trim())
                .then(
              (failure) {
                state.loading = false;
                if (failure != null) {
                  state.errorMessage = failure.message;
                } else if (!state.disposed) {
                  // Navigate to the reset password screen
                }
              },
            );
          } else {
            state.autoValidateMode = AutovalidateMode.always;
          }
        },
        emailFocus: state.emailFocus,
        onTapEmail: () {
          state.errorMessage = null;
          Future.delayed(
            const Duration(milliseconds: 600),
            () => state.onFocusEmail(true),
          );
        },
      );

  @override
  ForgotPasswordState buildState() => ForgotPasswordState();
}
