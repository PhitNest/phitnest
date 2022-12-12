import 'package:flutter/material.dart';

import '../../../common/validators.dart';
import '../provider.dart';
import './forgot_password_state.dart';
import './forgot_password_view.dart';

class ForgotPasswordProvider
    extends ScreenProvider<ForgotPasswordState, ForgotPasswordView> {
  const ForgotPasswordProvider() : super();

  @override
  ForgotPasswordView build(BuildContext context, ForgotPasswordState state) =>
      ForgotPasswordView(
        scrollController: state.scrollController,
        emailAddressController: state.emailAddressController,
        errorMessage: state.errorMessage,
        loading: state.loading,
        formKey: state.formKey,
        autovalidateMode: state.autovalidateMode,
        validateEmail: (value) => validateEmail(value),
        onPressedsubmit: () {
          state.loading = true;
          state.errorMessage = null;
          if (state.formKey.currentState!.validate()) {
            // Call use case
          } else {
            state.autovalidateMode = AutovalidateMode.always;
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
